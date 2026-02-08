import 'package:drift/drift.dart' hide Table;
import 'package:roz_hazri/core/database/tables/wagecycle_table.dart';
import '../../core/database/app_database.dart';

class PayrollperiodRepository {
  final AppDatabase _db;

  PayrollperiodRepository(this._db);

  Future<PayrollperiodTableData?> getCurrentPeriod() async {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);

    return (_db.select(_db.payrollperiodTable)..where(
          (tbl) =>
              tbl.startDate.isSmallerOrEqualValue(date) &
              tbl.endDate.isBiggerOrEqualValue(date) &
              tbl.isClosed.equals(false),
        ))
        .getSingleOrNull();
  }

  Future<PayrollperiodTableData> closeCurrentPeriod() async {
    final current = await getCurrentPeriod();

    if (current == null) {
      throw Exception("No active payroll period.");
    }

    await _db
        .update(_db.payrollperiodTable)
        .replace(current.copyWith(isClosed: true));

    return current.copyWith(isClosed: true);
  }

  Future<List<PayrollperiodTableData>> getPeriodHistory() async {
    return (_db.select(
      _db.payrollperiodTable,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.startDate)])).get();
  }

  Future<PayrollperiodTableData> generateNextPeriod({
    required int cycleId,
  }) async {
    // Fetch the wage cycle configuration
    final cycle = await (_db.select(
      _db.wagecycleTable,
    )..where((tbl) => tbl.id.equals(cycleId))).getSingleOrNull();

    if (cycle == null) {
      throw Exception("Wage cycle not found.");
    }

    // Fetch the latest payroll period for continuity

    final lastPeriod =
        await (_db.select(_db.payrollperiodTable)
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.endDate)])
              ..limit(1))
            .getSingleOrNull();

    DateTime startDate;

    if (lastPeriod == null) {
      // First payroll period
      startDate = DateTime(
        cycle.startFromDate.year,
        cycle.startFromDate.month,
        cycle.startFromDate.day,
      );
    } else {
      if (!lastPeriod.isClosed) {
        throw Exception(
          "Cannot create next period. Previous period is still open.",
        );
      }

      final next = lastPeriod.endDate.add(const Duration(days: 1));
      startDate = DateTime(next.year, next.month, next.day);
    }

    // Calculate endDate using cycle configuration
    DateTime endDate = startDate.add(Duration(days: cycle.cycleLengthDays - 1));

    // Apply monthly adjustment if needed

    if (cycle.cycleType == CycleType.monthly && cycle.autoAdjustMonthEnd) {
      final lastDayOfMonth = DateTime(
        endDate.year,
        endDate.month + 1,
        0,
      ); // last day of that month
      if (endDate.day > lastDayOfMonth.day) {
        endDate = DateTime(
          endDate.year,
          endDate.month,
          lastDayOfMonth.day,
          23,
          59,
          59,
        );
      } else {
        endDate = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          23,
          59,
          59,
        );
      }
    } else {
      // For weekly/biweekly/custom
      endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    }

    // Calculate payDate using cycle.payDay

    DateTime payDate;
    if (cycle.cycleType == CycleType.monthly) {
      // Pay day in the same month as endDate
      final lastDayOfMonth = DateTime(endDate.year, endDate.month + 1, 0).day;
      final day = cycle.payDay > lastDayOfMonth ? lastDayOfMonth : cycle.payDay;
      payDate = DateTime(endDate.year, endDate.month, day, 12, 0); // 12:00 noon
    } else {
      // For weekly/biweekly/custom, pay on endDate
      payDate = endDate;
    }

    // Insert the new payroll period

    final id = await _db
        .into(_db.payrollperiodTable)
        .insert(
          PayrollperiodTableCompanion.insert(
            cycleId: cycleId,
            startDate: startDate,
            endDate: endDate,
            payDate: payDate,
            isClosed: false,
            createdAt: DateTime.now(),
          ),
        );

    // Return the inserted period
    return (_db.select(
      _db.payrollperiodTable,
    )..where((tbl) => tbl.id.equals(id))).getSingle();
  }
}
