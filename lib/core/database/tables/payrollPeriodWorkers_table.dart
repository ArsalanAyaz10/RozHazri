import 'package:drift/drift.dart';
import 'package:roz_hazri/core/database/tables/payrollPeriod_table.dart';
import 'package:roz_hazri/core/database/tables/worker_table.dart';

class PayrollPeriodWorkersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get periodId => integer().references(PayrollperiodTable, #id)();
  IntColumn get workerId => integer().references(Workers, #id)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {periodId, workerId}
      ];
}
