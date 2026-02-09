import 'package:drift/drift.dart';
import 'package:roz_hazri/core/database/app_database.dart';

class PayrollPeriodWorkersRepository {
  final AppDatabase _db;

  PayrollPeriodWorkersRepository(this._db);

  Future<void> addWorkersToPeriod(int periodId, List<int> workerIds) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.payrollPeriodWorkersTable,
        workerIds.map((id) => PayrollPeriodWorkersTableCompanion.insert(
              periodId: periodId,
              workerId: id,
            )),
      );
    });
  }

  Future<List<Worker>> getWorkersForPeriod(int periodId) async {
    final query = _db.select(_db.workers).join([
      innerJoin(
          _db.payrollPeriodWorkersTable,
          _db.payrollPeriodWorkersTable.workerId
              .equalsExp(_db.workers.id)),
    ])
      ..where(_db.payrollPeriodWorkersTable.periodId.equals(periodId));

    final result = await query.get();
    return result.map((row) => row.readTable(_db.workers)).toList();
  }

  Future<void> removeWorkerFromPeriod(int periodId, int workerId) async {
    await (_db.delete(_db.payrollPeriodWorkersTable)
          ..where((t) => t.periodId.equals(periodId) & t.workerId.equals(workerId)))
        .go();
  }
}
