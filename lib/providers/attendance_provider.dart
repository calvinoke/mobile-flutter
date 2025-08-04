import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/model_class/attendanceinfo.dart';

class AttendanceProvider extends ChangeNotifier {
  final studentIdController = TextEditingController();
  final studentNameController = TextEditingController();
  final classController = TextEditingController();
  final sectionController = TextEditingController();

  DateTime? attendanceDate;
  String? attendanceStatus;

  bool isLoading = false;

  List<AttendanceInfo> _attendances = [];

  bool _isFetching = false;
  String? _error;

  // Use this getter name consistently:
  List<AttendanceInfo> get attendanceList => _attendances;

  bool get isFetching => _isFetching;
  bool get loading => isLoading;
  String? get error => _error;

  Future<void> fetchAttendance() async {
    _isFetching = true;
    _error = null;
    notifyListeners();

    try {
      final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.isEmpty) throw Exception("API_BASE_URL not found");

      final response = await http.get(Uri.parse('$baseUrl/getattendance'));

      if (response.statusCode == 200) {
        _attendances = List<AttendanceInfo>.from(
          json.decode(response.body).map((x) => AttendanceInfo.fromJson(x)),
        );
      } else {
        _error = 'Failed to load attendance data: ${response.statusCode}';
        _attendances = [];
      }
    } catch (e) {
      _error = 'Error: $e';
      _attendances = [];
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<void> searchByStudentId(String studentId) async {
    if (studentId.isEmpty) {
      _attendances = [];
      _error = null;
      notifyListeners();
      return;
    }

    isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
      if (baseUrl.isEmpty) throw Exception("API_BASE_URL not found");

      final response = await http.get(Uri.parse('$baseUrl/studentattendance/$studentId'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        _attendances = jsonData.map((item) => AttendanceInfo.fromJson(item)).toList();
      } else {
        _error = 'Failed to fetch attendance: ${response.statusCode}';
        _attendances = [];
      }
    } catch (e) {
      _error = 'Error: $e';
      _attendances = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> studentIdChanged() async {
    final studentId = studentIdController.text.trim();
    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.isEmpty) {
      debugPrint('API_BASE_URL not found in .env');
      return;
    }

    if (studentId.isEmpty) {
      clearFields();
      return;
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/student/$studentId'));

      if (response.statusCode == 200) {
        final studentData = jsonDecode(response.body);
        studentNameController.text = studentData['name'] ?? '';
        classController.text = studentData['class'] ?? '';
        sectionController.text = studentData['section'] ?? '';
      } else {
        clearFields();
      }
    } catch (e) {
      debugPrint('Error fetching student data: $e');
      clearFields();
    }
    notifyListeners();
  }

  void clearFields() {
    studentNameController.clear();
    classController.clear();
    sectionController.clear();
    notifyListeners();
  }

  void setAttendanceDate(DateTime date) {
    attendanceDate = date;
    notifyListeners();
  }

  void setAttendanceStatus(String? status) {
    attendanceStatus = status;
    notifyListeners();
  }

  Future<bool> takeAttendance() async {
    if (attendanceDate == null || attendanceStatus == null) return false;

    final attendance = AttendanceInfo(
      attendanceId: null,
      studentId: int.tryParse(studentIdController.text.trim()),
      studentName: studentNameController.text.trim(),
      class1: classController.text.trim(),
      section: sectionController.text.trim(),
      attendanceDate: attendanceDate!.toIso8601String(),
      attendanceStatus: attendanceStatus!,
    );

    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.isEmpty) return false;

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/takeattendance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(attendance.toJson()),
      );

      if (response.statusCode == 200) {
        resetForm();
        return true;
      }
    } catch (e) {
      debugPrint('Error submitting attendance: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return false;
  }

  void resetForm() {
    studentIdController.clear();
    studentNameController.clear();
    classController.clear();
    sectionController.clear();
    attendanceDate = null;
    attendanceStatus = null;
    notifyListeners();
  }

  @override
  void dispose() {
    studentIdController.dispose();
    studentNameController.dispose();
    classController.dispose();
    sectionController.dispose();
    super.dispose();
  }
}
