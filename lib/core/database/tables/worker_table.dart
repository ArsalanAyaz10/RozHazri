import 'package:drift/drift.dart';

class Workers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get phone => text().nullable()();
  TextColumn get paymentType => text().withDefault(const Constant('DAILY'))();
  RealColumn get rate => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}