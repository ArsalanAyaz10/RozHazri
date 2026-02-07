import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';

class WorkerRepository {
  final AppDatabase _db;

  WorkerRepository(this._db);

  Future<List<Worker>> getAllWorkers() => _db.select(_db.workers).get();

  Future<List<Worker>> searchWorkers(String query) {
    return (_db.select(_db.workers)..where((t) => t.name.like('%$query%'))).get();
  }

  // Insert worker
  Future<int> addWorker(WorkersCompanion worker) => _db.into(_db.workers).insert(worker);

  // Update worker
  Future<bool> updateWorker(Worker worker) => _db.update(_db.workers).replace(worker);

  // Delete
  Future<int> deleteWorker(int id) => (_db.delete(_db.workers)..where((t) => t.id.equals(id))).go();
}
