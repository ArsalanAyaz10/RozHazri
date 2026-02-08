import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';

class AttendanceRepository {
  final AppDatabase _db;

  AttendanceRepository(this._db);

  // DB Queries
  Future<List<AttendanceData>> getAllAttendance() {
    return _db.select(_db.attendance).get();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Stream<List<AttendanceData>> watchAttendanceByDate(DateTime date) {
  final normalizedDate = _normalizeDate(date);
  return (_db.select(_db.attendance)..where((tbl) => tbl.date.equals(normalizedDate))).watch();
}

  Future<void> addAttendance(AttendanceCompanion attendance) {
    // Ensure the date being inserted is normalized
    final normalizedDate = _normalizeDate(attendance.date.value);
    final updatedAttendance = attendance.copyWith(
      date: Value(normalizedDate),
    );
    
    // insertOrReplace correctly handles the (workerId, date) unique constraint
    return _db.into(_db.attendance).insert(updatedAttendance, mode: InsertMode.insertOrReplace);
  }

  Future<List<AttendanceData>> getAttendanceByWorker(int workerId) {
    return (_db.select(
      _db.attendance,
    )..where((tbl) => tbl.workerId.equals(workerId))).get();
  }

  Future<List<AttendanceData>> getAttendanceByDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    return (_db.select(
      _db.attendance,
    )..where((tbl) => tbl.date.equals(normalizedDate))).get();
  }

  Stream<List<AttendanceData>> watchAttendance(int workerId) {
    return (_db.select(
      _db.attendance,
    )..where((t) => t.workerId.equals(workerId))).watch();
  }

  // BUSINESS LOGIC

  /// Attendance Wage based on Status
  double _calculateAttendanceWage({
    required double dailyWage,
    required String status,
  }) {
    switch (status) {
      case 'P':
        return dailyWage;

      case 'H':
        return dailyWage / 2;

      case 'A':
      default:
        return 0;
    }
  }

  /// Hourly wage from daily wage
  double _calculateHourlyRate(double dailyWage) {
    return dailyWage / 8;
  }

  /// Overtime Pay
  double _calculateOvertimePay({
    required double dailyWage,
    required double overtimeHours,
  }) {
    final hourlyRate = _calculateHourlyRate(dailyWage);
    return hourlyRate * overtimeHours;
  }

  /// Total Pay For One Attendance Record
  double calculateDailyPay({
    required Worker worker,
    required AttendanceData attendance,
  }) {
    final attendancePay = _calculateAttendanceWage(
      dailyWage: worker.rate,
      status: attendance.status,
    );

    final overtimePay = _calculateOvertimePay(
      dailyWage: worker.rate,
      overtimeHours: attendance.overtimeHours,
    );

    return attendancePay +
        overtimePay +
        attendance.bonus -
        attendance.deduction;
  }

  // MONTHLY SALARY CALCULATION

  Future<double> calculateMonthlySalary({
    required Worker worker,
    required DateTime month,
  }) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);

    final records =
        await (_db.select(_db.attendance)..where(
              (tbl) =>
                  tbl.workerId.equals(worker.id) &
                  tbl.date.isBetweenValues(start, end),
            ))
            .get();

    double total = 0;

    for (final record in records) {
      total += calculateDailyPay(worker: worker, attendance: record);
    }

    return total;
  }
}
