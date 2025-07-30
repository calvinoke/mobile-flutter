import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExamFormProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  String examTitle = '';
  String selectedClass = '';
  String selectedSection = '';
  String selectedSubject = '';
  String examType = '';
  String examHall = '';
  DateTime? examDate;
  TimeOfDay? examStartTime;
  TimeOfDay? examEndTime;
  String selectedInvigilator = '';
  bool isLoading = false;

  List<String> subjectList = [];

  List<String> get invigilators => ['Calvin Oker', 'Owiny Paul', 'Okello Peter'];

  void updateSubjectList() {
    subjectList = (selectedClass == '9th' || selectedClass == '10th')
        ? ['Math', 'Physics', 'Chemistry', 'Accounting', 'Finance']
        : ['History', 'English', 'Math', 'Science'];
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: examDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      examDate = picked;
      notifyListeners();
    }
  }

  Future<void> pickTime(BuildContext context, {required bool isStartTime}) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      if (isStartTime) {
        examStartTime = picked;
      } else {
        examEndTime = picked;
      }
      notifyListeners();
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (examDate == null || examStartTime == null || examEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select exam date and time')),
      );
      return;
    }

    formKey.currentState!.save();

    final startDateTime = DateTime(
      examDate!.year,
      examDate!.month,
      examDate!.day,
      examStartTime!.hour,
      examStartTime!.minute,
    );
    final endDateTime = DateTime(
      examDate!.year,
      examDate!.month,
      examDate!.day,
      examEndTime!.hour,
      examEndTime!.minute,
    );

    final body = {
      "title": examTitle,
      "class": selectedClass,
      "section": selectedSection,
      "subject": selectedSubject,
      "type": examType,
      "hall": examHall,
      "date": examDate!.toIso8601String(),
      "start_time": startDateTime.toIso8601String(),
      "end_time": endDateTime.toIso8601String(),
      "invigilator": selectedInvigilator,
    };

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(dotenv.env['API_URL']!),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exam schedule submitted successfully!')),
        );
        resetForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetForm() {
    formKey.currentState?.reset();
    examTitle = '';
    selectedClass = '';
    selectedSection = '';
    selectedSubject = '';
    examType = '';
    examHall = '';
    examDate = null;
    examStartTime = null;
    examEndTime = null;
    selectedInvigilator = '';
    subjectList = [];
    notifyListeners();
  }
}
