import 'package:drift/drift.dart' hide Table;
import 'package:roz_hazri/core/database/tables/wagecycle_table.dart';
import '../../core/database/app_database.dart';

class PayrollperiodRepository {
  final AppDatabase _db;

  PayrollperiodRepository(this._db);

  Future<PayrollperiodTableData?> getCurrentPeriod() async {
    return getPeriodByDate(DateTime.now());
  }

  Future<PayrollperiodTableData?> getPeriodByDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    return (_db.select(_db.payrollperiodTable)..where(
          (tbl) =>
              tbl.startDate.isSmallerOrEqualValue(normalizedDate) &
              tbl.endDate.isBiggerOrEqualValue(normalizedDate) &
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

    // Calculate endDate: Strict 15-day rule (Start + 14 days)
    DateTime endDate = startDate.add(const Duration(days: 14));

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
            createdAt: Value(DateTime.now()),
          ),
        );

    // Return the inserted period
    return (_db.select(
      _db.payrollperiodTable,
    )..where((tbl) => tbl.id.equals(id))).getSingle();
  }
}
