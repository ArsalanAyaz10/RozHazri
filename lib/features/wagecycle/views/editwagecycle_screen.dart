import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roz_hazri/core/database/tables/wagecycle_table.dart';
import 'package:roz_hazri/features/wagecycle/controllers/wagecycle_controller.dart';

class PayrollSettingsScreen extends GetView<WageCycleController> {
  const PayrollSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Payroll Settings",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel("CYCLE TYPE"),
            _buildCycleTypeSelector(),
            const SizedBox(height: 24),
            _buildSectionLabel("Cycle Length (Days)"),
            _buildNumericInput(
              icon: Icons.calendar_today,
              value: controller.cycleLength,
              onChanged: (val) => controller.cycleLength.value = int.parse(val),
            ),
            const SizedBox(height: 24),
            _buildDatePickerTile(context),
            const SizedBox(height: 24),
            _buildSectionLabel("Monthly Pay Day (1-31)"),
            _buildNumericInput(
              icon: Icons.money,
              value: controller.payDay,
              onChanged: (val) => controller.payDay.value = int.parse(val),
            ),
            const SizedBox(height: 24),
            _buildAutoAdjustSwitch(),
            const SizedBox(height: 32),
            _buildLogicPreview(),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildCycleTypeSelector() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: CycleType.values.map((type) {
            bool isSelected = controller.selectedCycle.value == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectedCycle.value = type,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    type.name.capitalizeFirst!,
                    style: TextStyle(
                      color: isSelected ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDatePickerTile(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.calendar_month, color: Colors.green),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Policy Start Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "First day of active cycle",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Obx(
            () => TextButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.startDate.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) controller.startDate.value = picked;
              },
              child: Text(
                DateFormat('MMM dd, yyyy').format(controller.startDate.value),
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogicPreview() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, height: 1.5),
                  children: [
                    const TextSpan(
                      text: "LOGIC PREVIEW\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(text: "Workers will be paid every "),
                    TextSpan(
                      text: "${controller.cycleLength.value} days ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(text: "starting from the "),
                    TextSpan(
                      text:
                          "${DateFormat('d').format(controller.startDate.value)} of the month. ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const TextSpan(
                      text:
                          "Next payroll will be processed automatically on the selected pay date.",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () => controller.saveSettings(),
        icon: const Icon(Icons.save),
        label: const Text("Save Configuration"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Helper widgets for labels and inputs...
  Widget _buildSectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    ),
  );

  Widget _buildNumericInput({
    required IconData icon,
    required RxInt value,
    required Function(String) onChanged,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        hintText: value.value.toString(),
      ),
    );
  }

  Widget _buildAutoAdjustSwitch() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () => SwitchListTile(
          title: const Text(
            "Auto-adjust for Month End",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            "Handle shorter months automatically",
            style: TextStyle(fontSize: 12),
          ),
          value: controller.autoAdjust.value,
          activeColor: Colors.green,
          onChanged: (val) => controller.autoAdjust.value = val,
        ),
      ),
    );
  }
}
