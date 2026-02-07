import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// Import your table definitions
import 'tables/worker_table.dart';
import 'tables/attendance_table.dart';

// The generated file part (one for the whole DB)
part 'app_database.g.dart';

@DriftDatabase(tables: [Workers, Attendance])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Incremented because we added a new table

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'roz_hazri_db');
  }

   @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
         await m.createTable(attendance);
        }
      },
    );
  }
}
