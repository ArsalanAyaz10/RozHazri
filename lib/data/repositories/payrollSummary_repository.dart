import '../../core/database/app_database.dart';

class PayrollSummaryRepository {
  final AppDatabase _db;

  PayrollSummaryRepository(this._db);

  Future<void> saveSummaries(List<PayrollSummaryTableCompanion> summaries) async {
    await _db.batch((batch) {
      batch.insertAll(_db.payrollSummaryTable, summaries);
    });
  }

  Future<List<PayrollSummaryTableData>> getSummariesForPeriod(int periodId) {
    return (_db.select(_db.payrollSummaryTable)..where((t) => t.periodId.equals(periodId))).get();
  }
}
