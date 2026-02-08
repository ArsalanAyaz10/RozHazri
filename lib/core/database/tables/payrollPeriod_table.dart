import 'package:drift/drift.dart';
import 'package:roz_hazri/core/database/tables/wagecycle_table.dart';


class PayrollperiodTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId => integer().references(WagecycleTable, #id)();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get payDate => dateTime()();
  BoolColumn get isClosed => boolean()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/*id
cycleId
startDate
endDate
payDate
isClosed
createdAt
*/
