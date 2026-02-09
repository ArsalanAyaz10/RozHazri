import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';

class WorkerRepository {
  final AppDatabase _db;

  WorkerRepository(this._db);

  Future<List<Worker>> getAllWorkers() =>
      (_db.select(_db.workers)..where((t) => t.deletedAt.isNull())).get();

  Future<List<Worker>> searchWorkers(String query) {
    return (_db.select(_db.workers)
          ..where((t) => t.name.like('%$query%') & t.deletedAt.isNull()))
        .get();
  }

  // Insert worker
  Future<int> addWorker(WorkersCompanion worker) =>
      _db.into(_db.workers).insert(worker);

  // Update worker
  Future<bool> updateWorker(Worker worker) =>
      _db.update(_db.workers).replace(worker);

  // Soft Delete
  Future<int> deleteWorker(int id) {
    return (_db.update(_db.workers)..where((t) => t.id.equals(id)))
        .write(WorkersCompanion(deletedAt: Value(DateTime.now())));
  }
}
