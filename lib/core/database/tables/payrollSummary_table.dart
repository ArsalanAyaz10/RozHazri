import 'package:drift/drift.dart';
import 'package:roz_hazri/core/database/tables/payrollPeriod_table.dart';
import 'package:roz_hazri/core/database/tables/worker_table.dart';

class PayrollSummaryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId => integer().references(PayrollperiodTable, #id)();
  IntColumn get workerId => integer().references(Workers, #id)();
  
  // Snapshots of data at the time of closing
  TextColumn get workerName => text()();
  RealColumn get workerRate => real()();
  RealColumn get totalWage => real()();
  RealColumn get overtimePay => real()();
  RealColumn get bonus => real()();
  RealColumn get deduction => real()();
  IntColumn get totalDaysPresent => integer()();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
