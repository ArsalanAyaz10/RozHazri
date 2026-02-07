import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roz_hazri/core/utils/fonts.dart';
import 'package:roz_hazri/features/worker/controllers/addworker_controller.dart';

class AddworkerScreen extends GetView<AddworkerController> {
  const AddworkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add New Worker',
          style: TextStyle(
            fontFamily: AppFonts.outfit,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Worker Details"),
            const SizedBox(height: 15),
            _buildLabel("Worker Name"),
            _buildTextField(controller.nameController, "e.g., Ahmed Ali"),
            const SizedBox(height: 20),
            _buildLabel("Phone Number"),
            _buildTextField(
              controller.phoneController,
              "+92 0000-00000",
              isPhone: true,
            ),

            const SizedBox(height: 30),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 20),

            _buildSectionHeader("Wage Configuration"),
            const SizedBox(height: 20),

            // Wage Type Toggle
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => Row(
                  children: controller.wageTypes.map((type) {
                    bool isSelected = controller.selectedWageType.value == type;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => controller.setWageType(type),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            type,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 25),
            _buildLabel("Rate Amount (Rs)"),
            _buildTextField(
              controller.rateController,
              "0.00",
              isCurrency: true,
            ),

            const SizedBox(height: 40),

            // Inside AddworkerScreen...
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isSaving.value
                      ? null
                      : () => controller.saveWorker(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: controller.isSaving.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Save Worker",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F1F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Components ---

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint, {
    bool isPhone = false,
    bool isCurrency = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: (isPhone || isCurrency)
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        prefixIcon: isCurrency
            ? const Padding(
                padding: EdgeInsets.all(14.0),
                child: Text(
                  "Rs",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
        ),
      ),
    );
  }
}
