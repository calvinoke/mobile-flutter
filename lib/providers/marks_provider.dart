import 'package:flutter/material.dart';

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

  MarksProvider() {
    studentClass.addListener(updateSubjects);
  }

  void updateSubjects() {
    final className = studentClass.text.trim();
    subjects.clear();
    subjectControllers.clear();

    if (['1st', '2nd', '3rd', '4th', '5th'].contains(className)) {
      subjects.addAll(['SST', 'English', 'Mathematics', 'Science']);
    } else if (['6th', '7th', '8th'].contains(className)) {
      subjects.addAll(['SST', 'English', 'Mathematics', 'Science', 'Religion', 'Sociology', 'Agriculture']);
    } else if (className == '9th' || className == '10th') {
      subjects.addAll(['SST', 'English', 'General Math', 'Religion', 'Physics', 'Chemistry', 'Biology']);
    } else if (['11th', '12th'].contains(className)) {
      subjects.addAll(['SST', 'English', 'Math', 'Finance', 'Accounting']);
    }

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

  void disposeControllers() {
    examTitle.dispose();
    studentId.dispose();
    studentName.dispose();
    studentClass.dispose();
    subjectControllers.forEach((_, c) => c.dispose());
  }
}
