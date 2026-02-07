import 'package:drift/drift.dart';
import 'worker_table.dart';

class Attendance extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workerId => integer().references(Workers, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => text()(); // PRESENT, ABSENT, HALFDAY
  RealColumn get workingHours => real().withDefault(const Constant(0))();
  RealColumn get overtimeHours => real().withDefault(const Constant(0))();
  RealColumn get bonus => real().withDefault(const Constant(0))();
  RealColumn get deduction => real().withDefault(const Constant(0))();
  TextColumn get remarks => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
