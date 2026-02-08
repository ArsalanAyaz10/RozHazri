import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/data/repositories/payrollCycle_repository.dart';
import 'package:roz_hazri/data/repositories/payrollPeriod_repository.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';

class PayrollEngine {
  final AppDatabase _db;
  final WorkerRepository workerRepo;
  final PayrollperiodRepository periodRepo;
  final PayrollcycleRepository cycleRepo;

  PayrollEngine({
    required AppDatabase db,
    required this.workerRepo,
    required this.periodRepo,
    required this.cycleRepo,
  }) : _db = db;

  /// Calculate salaries for the current payroll period
  Future<List<PayrollResult>> calculateCurrentPeriod() async {
    // 1️⃣ Get the current payroll period
    final period = await periodRepo.getCurrentPeriod();
    if (period == null) {
      throw Exception("No active payroll period found.");
    }

    // 2️⃣ Fetch all workers
    final workers = await workerRepo.getAllWorkers();

    // 3️⃣ Fetch attendance for the period
    final allAttendance = await _db.select(_db.attendance).get();

    List<PayrollResult> results = [];

    for (final worker in workers) {
      // Filter attendance for this worker in current period
      final attendance = allAttendance.where(
        (a) =>
            a.workerId == worker.id &&
            !a.date.isBefore(period.startDate) &&
            !a.date.isAfter(period.endDate),
      );

      double totalWage = 0;

      for (final att in attendance) {
        double dailyWage = worker.rate;

        // Status: Full, Half, Absent
        if (att.status == 'HALFDAY') {
          dailyWage /= 2;
        } else if (att.status == 'ABSENT') {
          dailyWage = 0;
        }

        // Overtime: wage per hour
        double wagePerHour = worker.rate / 8.0;
        double overtimePay = wagePerHour * att.overtimeHours;

        // Add bonus and subtract deductions
        totalWage += dailyWage + overtimePay + att.bonus - att.deduction;
      }

      results.add(
        PayrollResult(
          workerId: worker.id,
          workerName: worker.name,
          totalWage: totalWage,
        ),
      );
    }

    return results;
  }

  /// Close the current payroll period
  Future<void> closeCurrentPeriod() async {
    await periodRepo.closeCurrentPeriod();
  }

  /// Generate next payroll period using an existing cycle
  Future<PayrollperiodTableData> generateNextPeriod({
    required int cycleId,
  }) async {
    return await periodRepo.generateNextPeriod(cycleId: cycleId);
  }
}

/// Result of payroll calculation per worker
class PayrollResult {
  final int workerId;
  final String workerName;
  final double totalWage;

  PayrollResult({
    required this.workerId,
    required this.workerName,
    required this.totalWage,
  });
}
