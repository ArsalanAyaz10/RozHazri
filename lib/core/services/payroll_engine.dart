import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/data/repositories/wageCycle_repository.dart';
import 'package:roz_hazri/data/repositories/payrollPeriod_repository.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';
import 'package:roz_hazri/data/repositories/payrollSummary_repository.dart';
import 'package:roz_hazri/data/repositories/payrollPeriodWorkers_repository.dart';
import 'package:drift/drift.dart' as drift;

class PayrollEngine {
  final AppDatabase _db;
  final WorkerRepository workerRepo;
  final PayrollperiodRepository periodRepo;
  final PayrollcycleRepository cycleRepo;
  final PayrollSummaryRepository summaryRepo;
  final PayrollPeriodWorkersRepository periodWorkerRepo;

  PayrollEngine({
    required AppDatabase db,
    required this.workerRepo,
    required this.periodRepo,
    required this.cycleRepo,
    required this.summaryRepo,
    required this.periodWorkerRepo,
  }) : _db = db;

  /// Validate if all workers registered for the period have attendance for every day
  Future<List<String>> validateAttendance() async {
    final period = await periodRepo.getCurrentPeriod();
    if (period == null) return [];

    final workers = await periodWorkerRepo.getWorkersForPeriod(period.id);
    if (workers.isEmpty) return ["No workers assigned to this payroll period."];

    final allAttendance = await _db.select(_db.attendance).get();

    List<String> errors = [];

    // Generate date range
    List<DateTime> dates = [];
    DateTime current = period.startDate;
    while (!current.isAfter(period.endDate)) {
      dates.add(DateTime(current.year, current.month, current.day));
      current = current.add(const Duration(days: 1));
    }

    for (final worker in workers) {
      for (final date in dates) {
        final hasMarking = allAttendance.any(
          (a) =>
              a.workerId == worker.id &&
              a.date.year == date.year &&
              a.date.month == date.month &&
              a.date.day == date.day,
        );

        if (!hasMarking) {
          errors.add(
            "Worker ${worker.name} missing attendance for ${date.day}/${date.month}",
          );
        }
      }
    }

    return errors;
  }

  /// Calculate salaries for the current payroll period (only for registered workers)
  Future<List<PayrollResult>> calculateCurrentPeriod() async {
    // 1️⃣ Get the current payroll period
    final period = await periodRepo.getCurrentPeriod();
    if (period == null) {
      throw Exception("No active payroll period found.");
    }

    // 2️⃣ Fetch workers assigned to this specific period
    final workers = await periodWorkerRepo.getWorkersForPeriod(period.id);

    // 3️⃣ Fetch attendance for the period
    final attendanceList = await (_db.select(_db.attendance)
          ..where(
            (tbl) => tbl.date.isBetweenValues(period.startDate, period.endDate),
          ))
        .get();

    List<PayrollResult> results = [];

    for (final worker in workers) {
      final workerAttendance =
          attendanceList.where((a) => a.workerId == worker.id);

      double dailyWageSum = 0;
      double overtimePaySum = 0;
      double bonusSum = 0;
      double deductionSum = 0;
      int daysPresent = 0;

      for (final att in workerAttendance) {
        double dailyWage = worker.rate;

        if (att.status == 'HALFDAY') {
          dailyWage /= 2;
          daysPresent += 1;
        } else if (att.status == 'ABSENT') {
          dailyWage = 0;
        } else if (att.status == 'PRESENT') {
          daysPresent += 1;
        }

        double wagePerHour = worker.rate / 8.0;
        double overtimePay = wagePerHour * att.overtimeHours;

        dailyWageSum += dailyWage;
        overtimePaySum += overtimePay;
        bonusSum += att.bonus;
        deductionSum += att.deduction;
      }

      results.add(
        PayrollResult(
          workerId: worker.id,
          workerName: worker.name,
          workerRate: worker.rate,
          totalWage: dailyWageSum + overtimePaySum + bonusSum - deductionSum,
          overtimePay: overtimePaySum,
          bonus: bonusSum,
          deduction: deductionSum,
          totalDaysPresent: daysPresent,
        ),
      );
    }

    return results;
  }

  /// Close the current payroll period and save snapshots
  Future<void> closeCurrentPeriod() async {
    final period = await periodRepo.getCurrentPeriod();
    if (period == null) return;

    // 1. Calculate final results
    final results = await calculateCurrentPeriod();

    // 2. Save Snapshots
    final summaries = results
        .map(
          (r) => PayrollSummaryTableCompanion.insert(
            periodId: period.id,
            workerId: r.workerId,
            workerName: r.workerName,
            workerRate: r.workerRate,
            totalWage: r.totalWage,
            overtimePay: r.overtimePay,
            bonus: r.bonus,
            deduction: r.deduction,
            totalDaysPresent: r.totalDaysPresent,
          ),
        )
        .toList();

    await summaryRepo.saveSummaries(summaries);

    // 3. Mark period as closed
    await periodRepo.closeCurrentPeriod();
  }

  /// Generate next payroll period using an existing cycle
  Future<PayrollperiodTableData> generateNextPeriod({
    required int cycleId,
  }) async {
    return await periodRepo.generateNextPeriod(cycleId: cycleId);
  }
}

/// Result of payroll calculation per worker
class PayrollResult {
  final int workerId;
  final String workerName;
  final double workerRate;
  final double totalWage;
  final double overtimePay;
  final double bonus;
  final double deduction;
  final int totalDaysPresent;

  PayrollResult({
    required this.workerId,
    required this.workerName,
    required this.workerRate,
    required this.totalWage,
    required this.overtimePay,
    required this.bonus,
    required this.deduction,
    required this.totalDaysPresent,
  });
}
