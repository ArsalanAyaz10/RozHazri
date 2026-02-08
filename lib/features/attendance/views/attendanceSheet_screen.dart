import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roz_hazri/core/utils/colors.dart';
import 'package:roz_hazri/core/utils/fonts.dart';
import 'package:roz_hazri/features/attendance/controllers/attendanceSheet_controller.dart';

class AttendanceSheetScreen extends GetView<AttendanceSheetController> {
  const AttendanceSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'View Attendance',
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHorizontalCalendar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    _buildSummaryCard(),
                    const SizedBox(height: 15),
                    _buildWorkerTable(),
                    const SizedBox(height: 20),
                    const Text(
                      "END OF DAILY REPORT",
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 10,
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(Duration(days: index));
          return Obx(() {
            final isSelected =
                controller.selectedDate.value.day == date.day &&
                controller.selectedDate.value.month == date.month &&
                controller.selectedDate.value.year == date.year;

            return GestureDetector(
              onTap: () => controller.updateSelectedDate(date),
              child: Container(
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGreen : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E').format(date).toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white70
                            : const Color(0xFF9E9E9E),
                      ),
                    ),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ATTENDANCE SUMMARY",
            style: TextStyle(
              color: Color(0xFF8E99A7),
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Present: ${controller.presentCount} / ${controller.workers.length}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              _statusBadge(
                "${controller.presentCount} P",
                const Color(0xFFE1F5EC),
                const Color(0xFF27AE60),
              ),
              const SizedBox(width: 5),
              _statusBadge(
                "${controller.absentCount} A",
                const Color(0xFFFFEBEB),
                const Color(0xFFEB5757),
              ),
              const SizedBox(width: 5),
              _statusBadge(
                "${controller.halfDayCount} H",
                const Color(0xFFFFF7E2),
                const Color(0xFFF2994A),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildWorkerTable() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFB),
              border: Border(bottom: BorderSide(color: Color(0xFFEBEBEB))),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    "WORKER NAME",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A6679),
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(
                  "STATUS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A6679),
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.workers.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, color: Color(0xFFEBEBEB)),
            itemBuilder: (context, index) {
              final worker = controller.workers[index];
              final status = controller.getWorkerStatus(worker.id);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        worker.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(status),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == "Present") return const Color(0xFF27AE60);
    if (status == "Absent") return const Color(0xFFEB5757);
    if (status == "Half-Day") return const Color(0xFFF2994A);
    return const Color(0xFF8E99A7);
  }
}
