import '../../core/database/app_database.dart';

class PayrollcycleRepository {
  final AppDatabase _db;

  PayrollcycleRepository(this._db);

  /*
saveCycleConfig()
getCycleConfig()
updateCycleConfig()
deleteCycleConfig()
  */

  Future<WagecycleTableData?> getCycleConfig() {
    return _db.select(_db.wagecycleTable).getSingleOrNull();
  }

  Future<int> saveCycleConfig(WagecycleTableCompanion wagecycle) async {
    return await _db.into(_db.wagecycleTable).insert(wagecycle);
  }

  Future<WagecycleTableData?> updateCycleConfig(
    WagecycleTableData data,
  ) async {
    await _db.update(_db.wagecycleTable).replace(data);
    return await getCycleConfig();
  }

  Future<void> deleteCycleConfig(WagecycleTableData data) async {
    await _db.delete(_db.wagecycleTable).delete(data);
  }
}
