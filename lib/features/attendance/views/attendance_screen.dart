import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Worker;
import 'package:intl/intl.dart';
import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/core/utils/colors.dart';
import 'package:roz_hazri/core/utils/fonts.dart';
import 'package:roz_hazri/features/attendance/controllers/attendance_controller.dart';

class MarkAttendanceScreen extends GetView<AttendanceController> {
  const MarkAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mark Attendance',
          style: TextStyle(
            fontFamily: AppFonts.outfit,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          iconSize: 22,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 246, 248, 246),
      body: Column(
        children: [
          _buildDateHeader(),
          _buildHorizontalCalendar(),
          Expanded(
            child: Obx(() {
              if (controller.activePeriod.value == null) {
                print(" CHECK VALUE: ${controller.activePeriod.value}");
                return _buildNoActiveShipmentView();
              } else {
                return Column(
                  children: [
                    _buildListHeader(),
                    _buildWorkerList(),
                    _buildBottomSummary(),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: Get.context!,
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  controller.onDateChange(picked);
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat(
                      'EEEE, d MMM yyyy',
                    ).format(controller.selectedDate.value),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar() {
    return SizedBox(
      height: 85,
      child: Obx(() {
        final currentSelected = controller.selectedDate.value;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: controller.calendarDates.length,
          itemBuilder: (context, index) {
            DateTime date = controller.calendarDates[index];
            bool isSelected = DateUtils.isSameDay(date, currentSelected);

            return GestureDetector(
              onTap: () => controller.onDateChange(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    Text(
                      DateFormat('d').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              "WORKER LIST (${controller.workers.length} TOTAL)",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Row(
            children: [
              Obx(
                () => Text(
                  "${controller.attendanceMap.length} Marked",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerList() {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.workers.length,
          itemBuilder: (context, index) {
            final worker = controller.workers[index];
            return _buildWorkerAttendanceCard(worker);
          },
        ),
      ),
    );
  }

  Widget _buildWorkerAttendanceCard(Worker worker) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Worker • ${worker.paymentType}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.info_outline, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          _buildStatusToggle(worker.id),
        ],
      ),
    );
  }

  Widget _buildStatusToggle(int workerId) {
    return Obx(() {
      String currentStatus = controller.attendanceMap[workerId] ?? "";
      return Row(
        children: [
          _statusButton(
            "Present",
            "P",
            Colors.green,
            currentStatus == "P",
            workerId,
          ),
          const SizedBox(width: 8),
          _statusButton(
            "Absent",
            "A",
            Colors.red,
            currentStatus == "A",
            workerId,
          ),
          const SizedBox(width: 8),
          _statusButton(
            "Half-day",
            "H",
            Colors.orange,
            currentStatus == "H",
            workerId,
          ),
        ],
      );
    });
  }

  Widget _statusButton(
    String label,
    String code,
    Color color,
    bool isSelected,
    int workerId,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.updateStatus(workerId, code),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => controller.saveAttendance(),
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                "Save Attendance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoActiveShipmentView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_clock, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            "No Active Shipment",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Please start a new wage cycle\nto mark attendance.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildReportButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () => Get.toNamed('/viewattendance'),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  "View Attendance Report",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
