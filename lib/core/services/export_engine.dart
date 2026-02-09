import 'dart:io';
import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:path_provider/path_provider.dart';

import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/data/repositories/payrollPeriod_repository.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';

import 'package:roz_hazri/data/repositories/payrollSummary_repository.dart';

class PayrollExportEngine {
  final AppDatabase _db;
  final WorkerRepository workerRepo;
  final PayrollperiodRepository periodRepo;
  final PayrollSummaryRepository summaryRepo;

  PayrollExportEngine({
    required AppDatabase db,
    required this.workerRepo,
    required this.periodRepo,
    required this.summaryRepo,
  }) : _db = db;

  Future<File> exportPayrollExcel(int periodId) async {
    final period = await (_db.select(
      _db.payrollperiodTable,
    )..where((tbl) => tbl.id.equals(periodId))).getSingle();

    // Create Excel
    final excel = Excel.createExcel();
    final sheet = excel['Payroll'];

    if (period.isClosed) {
      // 🟢 Use Snapshots for closed periods to avoid historical drift
      final summaries = await summaryRepo.getSummariesForPeriod(periodId);

      // Header Row
      List<CellValue> header = [
        TextCellValue("Worker Name"),
        TextCellValue("Daily Rate"),
        TextCellValue("Days Present"),
        TextCellValue("Overtime Pay"),
        TextCellValue("Bonus"),
        TextCellValue("Deduction"),
        TextCellValue("Total Wage"),
      ];
      sheet.appendRow(header);

      for (final summary in summaries) {
        sheet.appendRow([
          TextCellValue(summary.workerName),
          DoubleCellValue(summary.workerRate),
          IntCellValue(summary.totalDaysPresent),
          DoubleCellValue(summary.overtimePay),
          DoubleCellValue(summary.bonus),
          DoubleCellValue(summary.deduction),
          DoubleCellValue(summary.totalWage),
        ]);
      }
    } else {
      // 🟠 Real-time export for open periods
      final workers = await workerRepo.getAllWorkers();
      final attendanceList = await (_db.select(_db.attendance)
            ..where(
              (tbl) =>
                  tbl.date.isBetweenValues(period.startDate, period.endDate),
            ))
          .get();

      // Generate Date Headers
      List<DateTime> dateColumns = [];
      DateTime current = period.startDate;

      while (!current.isAfter(period.endDate)) {
        dateColumns.add(current);
        current = current.add(const Duration(days: 1));
      }

      // Header Row
      List<CellValue> header = [
        TextCellValue("Worker Name"),
        ...dateColumns.map((d) => TextCellValue("${d.day}-${d.month}")),
        TextCellValue("Overtime Hours"),
        TextCellValue("Total Wage"),
      ];

      sheet.appendRow(header);

      // Worker Rows
      for (final worker in workers) {
        double totalWage = 0;
        double totalOvertime = 0;

        List<CellValue> row = [TextCellValue(worker.name)];

        for (final date in dateColumns) {
          final attendance = attendanceList.firstWhereOrNull(
            (a) => a.workerId == worker.id && _isSameDate(a.date, date),
          );

          if (attendance == null) {
            row.add(TextCellValue("-"));
            continue;
          }

          row.add(TextCellValue(_statusSymbol(attendance.status)));

          double dailyWage = worker.rate;
          if (attendance.status == "HALFDAY") {
            dailyWage /= 2;
          } else if (attendance.status == "ABSENT") {
            dailyWage = 0;
          }

          double wagePerHour = worker.rate / 8;
          double overtimePay = wagePerHour * attendance.overtimeHours;
          totalOvertime += attendance.overtimeHours;
          totalWage +=
              dailyWage + overtimePay + attendance.bonus - attendance.deduction;
        }

        row.add(DoubleCellValue(totalOvertime));
        row.add(DoubleCellValue(totalWage));
        sheet.appendRow(row);
      }
    }

    // Save File
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/payroll_$periodId.xlsx");
    await file.writeAsBytes(excel.encode()!);

    return file;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _statusSymbol(String status) {
    switch (status) {
      case "PRESENT":
        return "P";
      case "ABSENT":
        return "A";
      case "HALFDAY":
        return "H";
      default:
        return "-";
    }
  }
}
