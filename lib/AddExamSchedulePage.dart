import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/exam_form_provider.dart';

final String apiUrl = dotenv.env['API_URL']!;

class AddExamSchedulePage extends StatefulWidget {
  @override
  _AddExamSchedulePageState createState() => _AddExamSchedulePageState();
}

class _AddExamSchedulePageState extends State<AddExamSchedulePage> {
  // Helper to update subject list based on selected class
  void _updateSubjectList(ExamFormProvider formProvider) {
    formProvider.updateSubjectList();
  }

  // Date picker handler
  Future<void> _pickDate(ExamFormProvider formProvider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: formProvider.examDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      formProvider.examDate = picked;
      formProvider.notifyListeners();
    }
  }

  // Time picker handler
  Future<void> _pickTime(ExamFormProvider formProvider, {required bool isStartTime}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (isStartTime) {
        formProvider.examStartTime = picked;
      } else {
        formProvider.examEndTime = picked;
      }
      formProvider.notifyListeners();
    }
  }

  // Submit exam schedule
  Future<void> _submitSchedule(ExamFormProvider formProvider) async {
    if (!formProvider.formKey.currentState!.validate()) return;

    if (formProvider.examDate == null ||
        formProvider.examStartTime == null ||
        formProvider.examEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select exam date and time')),
      );
      return;
    }

    formProvider.formKey.currentState!.save();

    final startDateTime = DateTime(
      formProvider.examDate!.year,
      formProvider.examDate!.month,
      formProvider.examDate!.day,
      formProvider.examStartTime!.hour,
      formProvider.examStartTime!.minute,
    );

    final endDateTime = DateTime(
      formProvider.examDate!.year,
      formProvider.examDate!.month,
      formProvider.examDate!.day,
      formProvider.examEndTime!.hour,
      formProvider.examEndTime!.minute,
    );

    final body = {
      "title": formProvider.examTitle,
      "class": formProvider.selectedClass,
      "section": formProvider.selectedSection,
      "subject": formProvider.selectedSubject,
      "type": formProvider.examType,
      "hall": formProvider.examHall,
      "date": formProvider.examDate!.toIso8601String(),
      "start_time": startDateTime.toIso8601String(),
      "end_time": endDateTime.toIso8601String(),
      "invigilator": formProvider.selectedInvigilator,
    };

    formProvider.isLoading = true;
    formProvider.notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exam schedule submitted successfully!')),
        );

        formProvider.formKey.currentState!.reset();
        formProvider.resetForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit. Server returned ${response.statusCode}.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission error: ${e.toString()}')),
      );
    } finally {
      formProvider.isLoading = false;
      formProvider.notifyListeners();
    }
  }

  Widget _buildTextField(String label, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onSaved: (value) => onSaved(value ?? ''),
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (val) => val == null || val.isEmpty ? 'Select $label' : null,
      ),
    );
  }

  Widget _buildDateTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('$label: $value'),
        trailing: Icon(Icons.calendar_today),
        onTap: onTap,
        tileColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<ExamFormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exam Schedule'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formProvider.formKey,
              child: ListView(
                children: [
                  _buildTextField('Exam Title', (val) => formProvider.examTitle = val),
                  _buildDropdown(
                    label: 'Class',
                    value: formProvider.selectedClass,
                    items: ['1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th'],
                    onChanged: (val) {
                      formProvider.selectedClass = val!;
                      _updateSubjectList(formProvider);
                    },
                  ),
                  if (['9th', '10th'].contains(formProvider.selectedClass))
                    _buildDropdown(
                      label: 'Section',
                      value: formProvider.selectedSection,
                      items: ['Science', 'Business Studies', 'Humanities'],
                      onChanged: (val) => formProvider.selectedSection = val!,
                    ),
                  _buildDropdown(
                    label: 'Subject',
                    value: formProvider.selectedSubject,
                    items: formProvider.subjectList,
                    onChanged: (val) => formProvider.selectedSubject = val!,
                  ),
                  _buildDropdown(
                    label: 'Exam Type',
                    value: formProvider.examType,
                    items: ['Theory', 'Practical'],
                    onChanged: (val) => formProvider.examType = val!,
                  ),
                  _buildTextField('Exam Hall', (val) => formProvider.examHall = val),
                  _buildDateTile(
                    label: 'Exam Date',
                    value: formProvider.examDate == null
                        ? 'Select Date'
                        : '${formProvider.examDate!.toLocal()}'.split(' ')[0],
                    onTap: () => _pickDate(formProvider),
                  ),
                  _buildDateTile(
                    label: 'Start Time',
                    value: formProvider.examStartTime == null
                        ? 'Select Start Time'
                        : formProvider.examStartTime!.format(context),
                    onTap: () => _pickTime(formProvider, isStartTime: true),
                  ),
                  _buildDateTile(
                    label: 'End Time',
                    value: formProvider.examEndTime == null
                        ? 'Select End Time'
                        : formProvider.examEndTime!.format(context),
                    onTap: () => _pickTime(formProvider, isStartTime: false),
                  ),
                  _buildDropdown(
                    label: 'Invigilator',
                    value: formProvider.selectedInvigilator,
                    items: formProvider.invigilators,
                    onChanged: (val) => formProvider.selectedInvigilator = val!,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: formProvider.isLoading ? null : () => _submitSchedule(formProvider),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text(formProvider.isLoading ? 'Submitting...' : 'Submit'),
                  ),
                ],
              ),
            ),
          ),
          if (formProvider.isLoading)
            Container(
              color: Colors.black45,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
