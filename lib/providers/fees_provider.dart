import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String API_URL = dotenv.env['API_URL'] ?? '';

class StudentInfo {
  final String name;
  final String studentClass;

  StudentInfo({required this.name, required this.studentClass});

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      name: json['name'],
      studentClass: json['class'],
    );
  }
}

class FeesProvider with ChangeNotifier {
  String? selectedMonth;
  String? selectedFeeType;
  String? selectedYear;

  List<String> months = [];
  List<String> feeTypes = [];
  List<String> years = [];

  String studentName = '';
  String studentClass = '';
  double totalFee = 0.0;
  double amountPaid = 0.0;
  double dueAmount = 0.0;
  String errorMessage = '';
  double fixedAmount = 0.0;

  bool isDropdownDataLoaded = false;

  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController feeAmountController = TextEditingController();

  FeesProvider() {
    loadDropdownData();
  }

  Future<void> loadDropdownData() async {
    try {
      final monthResponse = await http.get(Uri.parse('$API_URL/fees/months'));
      final feeTypeResponse = await http.get(Uri.parse('$API_URL/fees/types'));
      final yearResponse = await http.get(Uri.parse('$API_URL/fees/years'));

      if (monthResponse.statusCode == 200 &&
          feeTypeResponse.statusCode == 200 &&
          yearResponse.statusCode == 200) {
        months = List<String>.from(json.decode(monthResponse.body));
        feeTypes = List<String>.from(json.decode(feeTypeResponse.body));
        years = List<String>.from(json.decode(yearResponse.body));
        isDropdownDataLoaded = true;
        errorMessage = '';
      } else {
        errorMessage = 'Failed to load dropdown data.';
      }
    } catch (e) {
      errorMessage = 'Error loading dropdown data.';
    }
    notifyListeners();
  }

  Future<void> fetchStudentInfo(String studentId) async {
    try {
      final response = await http.get(Uri.parse('$API_URL/students/$studentId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final student = StudentInfo.fromJson(data);

        studentName = student.name;
        studentClass = student.studentClass;
        errorMessage = '';

        await updateFixedAmount();
      } else {
        studentName = '';
        studentClass = '';
        errorMessage = 'Student not found.';
      }
    } catch (e) {
      errorMessage = 'Failed to fetch student info.';
    }
    notifyListeners();
  }

  Future<void> updateFixedAmount() async {
    if (selectedFeeType == null || studentClass.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('$API_URL/fees/calculate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'class': studentClass,
          'feeType': selectedFeeType,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        fixedAmount = (data['amount'] as num).toDouble();
        errorMessage = '';
      } else {
        fixedAmount = 0.0;
        errorMessage = 'Fee amount not available.';
      }
    } catch (e) {
      errorMessage = 'Failed to fetch fee amount.';
    }
    notifyListeners();
  }

  void calculateFees() {
    errorMessage = '';
    final feeAmount = double.tryParse(feeAmountController.text.trim()) ?? 0.0;

    if (studentIdController.text.isEmpty ||
        feeAmount <= 0 ||
        selectedFeeType == null ||
        selectedMonth == null ||
        selectedYear == null) {
      errorMessage = 'Please fill all fields correctly.';
      notifyListeners();
      return;
    }

    totalFee = fixedAmount;
    amountPaid = feeAmount;
    dueAmount = totalFee - amountPaid;

    notifyListeners();
  }

  void onStudentIdChanged(String value) {
    if (value.isNotEmpty) {
      fetchStudentInfo(value);
    } else {
      studentName = '';
      studentClass = '';
      notifyListeners();
    }
  }

  void setSelectedFeeType(String? value) {
    selectedFeeType = value;
    updateFixedAmount();
  }

  void setSelectedMonth(String? value) {
    selectedMonth = value;
    notifyListeners();
  }

  void setSelectedYear(String? value) {
    selectedYear = value;
    notifyListeners();
  }

  @override
  void dispose() {
    studentIdController.dispose();
    feeAmountController.dispose();
    super.dispose();
  }
}
