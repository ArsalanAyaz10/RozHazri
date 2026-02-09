import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roz_hazri/core/database/tables/wagecycle_table.dart';
import 'package:roz_hazri/core/utils/colors.dart';
import 'package:roz_hazri/features/wagecycle/controllers/wagecycle_controller.dart';

class PayrollSetupScreen extends GetView<WageCycleController> {
  const PayrollSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Shipment Setup",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Configure Cycle",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Section 1: Cycle Details
              _buildCard(
                icon: Icons.calendar_today_outlined,
                title: "Cycle Details",
                children: [
                  _buildDropdownField(),
                  const SizedBox(height: 16),
                  _buildDatePickerField(context),
                ],
              ),

              const SizedBox(height: 16),

              // Section 2: Worker Selection
              _buildWorkerSelection(),

              const SizedBox(height: 16),

              // Logic Preview (from image_5be6b9.png)
              _buildLogicPreview(),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Shipment Cycle",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CycleType>(
              value: controller.selectedCycle.value,
              isExpanded: true,
              items: CycleType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.capitalizeFirst!),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) controller.selectedCycle.value = val;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Start Date",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: controller.startDate.value,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) controller.startDate.value = picked;
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(controller.startDate.value),
                ),
                const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogicPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F6ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  height: 1.5,
                ),
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
                    text:
                        "${controller.selectedCycle.value == CycleType.monthly ? 'month' : 'cycle'} ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const TextSpan(text: "starting from the "),
                  const TextSpan(text: "selected start date. "),
                  const TextSpan(
                    text:
                        "Next shipment will be processed according to the selected duration.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerSelection() {
    return _buildCard(
      icon: Icons.people_outline,
      title: "Select Workers",
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Select Workers to this cycle",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            TextButton(
              onPressed: () => controller.toggleSelectAll(),
              child: Obx(
                () => Text(
                  controller.selectedWorkerIds.length ==
                          controller.allWorkers.length
                      ? "Deselect All"
                      : "Select All",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.allWorkers.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("No workers found. Please add workers first."),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.allWorkers.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final worker = controller.allWorkers[index];
              final isSelected = controller.selectedWorkerIds.contains(
                worker.id,
              );
              return CheckboxListTile(
                value: isSelected,
                title: Text(worker.name, style: const TextStyle(fontSize: 14)),
                subtitle: Text(
                  worker.phone ?? "No phone",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                activeColor: Colors.green,
                contentPadding: EdgeInsets.zero,
                onChanged: (_) => controller.toggleWorkerSelection(worker.id),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton.icon(
          onPressed: () => controller.saveSettings(),
          icon: const Icon(Icons.save_outlined, color: Colors.black),
          label: const Text(
            "Save Configuration",
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF39D21F), // Neon Green from image
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
