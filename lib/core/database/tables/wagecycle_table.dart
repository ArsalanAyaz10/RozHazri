import 'package:drift/drift.dart';

enum CycleType { weekly, biweekly, monthly, custom }

class WagecycleTable extends Table {

  IntColumn get id => integer().autoIncrement()();
  TextColumn get cycleType => textEnum<CycleType>()();
  IntColumn get cycleLengthDays => integer()();
  IntColumn get payDay => integer()();
  BoolColumn get autoAdjustMonthEnd =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get startFromDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/*
id
cycleType
cycleLengthDays
payDay
autoAdjustMonthEnd
startFromDate
createdAt
updatedAt
*/
