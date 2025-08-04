import 'package:flutter/material.dart';

// Assuming you have a Marks model somewhere
import 'package:mobile/model_class/marks.dart';

class MarksProvider with ChangeNotifier {
  final examTitle = TextEditingController();
  final studentId = TextEditingController();
  final studentName = TextEditingController();
  final studentClass = TextEditingController();

  final Map<String, TextEditingController> subjectControllers = {};
  final List<String> subjects = [];

  double totalMarks = 0.0;
  double averageGrade = 0.0;
  String result = '';

  // List to store all marks entries
  List<Marks> _marksList = [];

  MarksProvider() {
    // Update subjects list and controllers when studentClass changes
    studentClass.addListener(updateSubjects);
  }

  void updateSubjects() {
    final className = studentClass.text.trim();

    // Clear existing subjects and dispose old controllers
    subjects.clear();
    subjectControllers.forEach((_, controller) => controller.dispose());
    subjectControllers.clear();

    // Define subjects based on class
    if (['1st', '2nd', '3rd', '4th', '5th'].contains(className)) {
      subjects.addAll(['SST', 'English', 'Mathematics', 'Science']);
    } else if (['6th', '7th', '8th'].contains(className)) {
      subjects.addAll(['SST', 'English', 'Mathematics', 'Science', 'Religion', 'Sociology', 'Agriculture']);
    } else if (className == '9th' || className == '10th') {
      subjects.addAll(['SST', 'English', 'General Math', 'Religion', 'Physics', 'Chemistry', 'Biology']);
    } else if (['11th', '12th'].contains(className)) {
      subjects.addAll(['SST', 'English', 'Math', 'Finance', 'Accounting']);
    }

    // Create new controllers for each subject
    for (var subject in subjects) {
      subjectControllers[subject] = TextEditingController();
    }

    notifyListeners();
  }

  double _calculateGrade(double marks) {
    if (marks < 33) return 0.0;
    if (marks <= 39) return 1.0;
    if (marks <= 49) return 2.0;
    if (marks <= 59) return 3.0;
    if (marks <= 69) return 3.5;
    if (marks <= 79) return 4.0;
    return 5.0;
  }

  void calculateResult() {
    double total = 0.0;
    final grades = <double>[];

    // Sum marks and calculate grades for each subject
    for (var controller in subjectControllers.values) {
      final marks = double.tryParse(controller.text.trim()) ?? 0.0;
      total += marks;
      grades.add(_calculateGrade(marks));
    }

    totalMarks = total;
    averageGrade = grades.isEmpty ? 0.0 : grades.reduce((a, b) => a + b) / grades.length;
    result = grades.any((grade) => grade == 0.0) ? 'FAIL' : 'PASS';

    notifyListeners();
  }

  // Add a Marks object to the list and notify listeners
  void addMarks(Marks marks) {
    _marksList.add(marks);
    notifyListeners();
  }

  // Getter for marks list
  List<Marks> get marksList => _marksList;

  // Dispose all text controllers to free resources
  void disposeControllers() {
    examTitle.dispose();
    studentId.dispose();
    studentName.dispose();
    studentClass.dispose();
    subjectControllers.forEach((_, c) => c.dispose());
  }
}
