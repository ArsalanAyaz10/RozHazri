import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roz_hazri/core/utils/colors.dart';
import 'package:roz_hazri/core/utils/fonts.dart';
import 'package:roz_hazri/features/worker/controllers/editworker_controller.dart';
import 'package:intl/intl.dart';

class EditworkerScreen extends GetView<EditworkerController> {
  const EditworkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Worker',
          style: TextStyle(
            fontFamily: AppFonts.outfit,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Full Name"),
              _buildTextField(controller.nameController, "Name"),

              const SizedBox(height: 20),
              _buildLabel("Phone Number"),
              _buildTextField(
                controller.phoneController,
                "Phone",
                isPhone: true,
                prefix: "+92 ",
              ),

              const SizedBox(height: 20),
              _buildLabel("Wage Rate"),
              _buildTextField(
                controller.rateController,
                "Rate",
                isRate: true,
                prefix: "Rs ",
              ),

              const SizedBox(height: 20),
              _buildLabel("Wage Type"),
              _buildWageToggle(),
              const SizedBox(height: 20),
              _buildAttendanceCalendar(),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => controller.updateWorker(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () => controller.deleteWorker(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Delete Worker",
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint, {
    bool isPhone = false,
    bool isRate = false,
    String? prefix,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: (isPhone || isRate)
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(
        prefixText: prefix,
        prefixStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildWageToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Light grey background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: controller.wageTypes.map((type) {
          return Expanded(
            child: Obx(() {
              // Checks if 'Daily', 'Hourly', or 'Fixed' matches controller state
              bool isSelected = controller.selectedWageType.value == type;

              return GestureDetector(
                onTap: () => controller.setWageType(type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    // Active state uses the primary green
                    color: isSelected
                        ? const Color(0xFF4CAF50)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    type,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontFamily: AppFonts.outfit,
                    ),
                  ),
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAttendanceCalendar() {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

    // Normalize Sunday (weekday 7) to start the grid correctly
    final firstDayWeekday = DateTime(now.year, now.month, 1).weekday;
    final firstDayOffset = firstDayWeekday == 7 ? 0 : firstDayWeekday - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Monthly Attendance",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat('MMMM yyyy').format(now),
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map(
                  (d) => Text(
                    d,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),

          // FIX: Wrap the builder but ensure attendanceRecords.value is accessed
          Obx(() {
            // Touching .length here tells GetX: "Rebuild this whenever the list changes"
            // This prevents the "improper use of GetX" error.
            controller.attendanceRecords.length;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 10,
              ),
              itemCount: daysInMonth + firstDayOffset,
              itemBuilder: (context, index) {
                if (index < firstDayOffset) return const SizedBox();

                final day = index - firstDayOffset + 1;
                final date = DateTime(now.year, now.month, day);
                final status = controller.getStatusForDate(date);

                Color dotColor = Colors.transparent;
                if (status == "P")
                  dotColor = AppColors.primaryGreen;
                else if (status == "A")
                  dotColor = AppColors.error;
                else if (status == "H")
                  dotColor = Colors.orange;

                return Column(
                  children: [
                    Text(
                      "$day",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CircleAvatar(radius: 3, backgroundColor: dotColor),
                  ],
                );
              },
            );
          }),
          const Divider(height: 32),
          Obx(() => _buildCalendarFooter()),
        ],
      ),
    );
  }

  Widget _buildCalendarFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statusIndicator(
          "Present",
          controller.presentCount.value,
          Colors.green,
        ),
        _statusIndicator("Absent", controller.absentCount.value, Colors.red),
        _statusIndicator("Half", controller.halfDayCount.value, Colors.orange),
      ],
    );
  }

  Widget _statusIndicator(String label, int count, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 6),
        Text(
          "$label: $count",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
