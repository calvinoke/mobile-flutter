import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'attendance_provider.dart';

class TakeAttendance extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  TakeAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Attendance'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 8.0,
          shadowColor: Colors.teal.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle('Student Information'),
                  buildTextFormField(
                    labelText: 'Student ID',
                    hintText: 'Enter Student ID',
                    controller: provider.studentIdController,
                    onChanged: (_) => provider.studentIdChanged(),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Student ID is required' : null,
                  ),
                  buildTextFormField(
                    labelText: 'Student Name',
                    hintText: 'Student Name',
                    controller: provider.studentNameController,
                    enabled: false,
                  ),
                  buildTextFormField(
                    labelText: 'Class',
                    hintText: 'Class',
                    controller: provider.classController,
                    enabled: false,
                  ),
                  buildTextFormField(
                    labelText: 'Section',
                    hintText: 'Section',
                    controller: provider.sectionController,
                    enabled: false,
                  ),
                  const SizedBox(height: 24),
                  sectionTitle('Attendance'),
                  buildDatePicker(context, provider),
                  buildAttendanceRadio(provider),
                  const SizedBox(height: 20),
                  Center(
                    child: provider.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              final success = await provider.takeAttendance();
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Attendance submitted successfully')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to submit attendance')),
                                );
                              }
                            },
                            child: const Text('Save Attendance'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
        ),
        Divider(thickness: 2, color: Colors.teal.shade700),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildTextFormField({
    required String labelText,
    required String hintText,
    required TextEditingController controller,
    bool enabled = true,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget buildDatePicker(BuildContext context, AttendanceProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance Date:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal.shade700),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: provider.attendanceDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              provider.setAttendanceDate(pickedDate);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: provider.attendanceDate != null
                  ? provider.attendanceDate!.toLocal().toString().split(' ')[0]
                  : 'Select Date',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            child: Text(provider.attendanceDate != null
                ? provider.attendanceDate!.toLocal().toString().split(' ')[0]
                : 'No date chosen'),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildAttendanceRadio(AttendanceProvider provider) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Present'),
            value: 'present',
            groupValue: provider.attendanceStatus,
            activeColor: Colors.teal.shade700,
            onChanged: (value) => provider.setAttendanceStatus(value),
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Absent'),
            value: 'absent',
            groupValue: provider.attendanceStatus,
            activeColor: Colors.teal.shade700,
            onChanged: (value) => provider.setAttendanceStatus(value),
          ),
        ),
      ],
    );
  }
}
