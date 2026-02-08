import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// Import your table definitions

import 'tables/worker_table.dart';
import 'tables/attendance_table.dart';
import 'tables/wagecycle_table.dart';
import 'tables/payrollPeriod_table.dart';

// The generated file part
part 'app_database.g.dart';

@DriftDatabase(
  tables: [Workers, Attendance, WagecycleTable, PayrollperiodTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

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
        if (from < 3) {
          await m.createTable(wagecycleTable);
          await m.createTable(payrollperiodTable);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'roz_hazri_db');
  }
}
