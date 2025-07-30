import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/model_class/AttendanceInfo.dart';

class AttendanceProvider extends ChangeNotifier {
  // Controllers for attendance input form fields
  final studentIdController = TextEditingController();
  final studentNameController = TextEditingController();
  final classController = TextEditingController();
  final sectionController = TextEditingController();

  DateTime? attendanceDate;
  String? attendanceStatus;

  bool isLoading = false;

  // List and status for attendance records fetched from backend
  List<AttendanceInfo> _attendances = [];
  bool _isFetching = false;
  String? _fetchError;

  List<AttendanceInfo> get attendances => _attendances;
  bool get isFetching => _isFetching;
  String? get fetchError => _fetchError;

  /// Fetch all attendance records
  Future<void> fetchAttendance() async {
    _isFetching = true;
    _fetchError = null;
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
        _fetchError = 'Failed to load attendance data: ${response.statusCode}';
        _attendances = [];
      }
    } catch (e) {
      _fetchError = 'Error: $e';
      _attendances = [];
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  /// Fetch student details by ID and populate form fields
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

  /// Submit attendance record to backend
  Future<bool> takeAttendance() async {
    if (attendanceDate == null || attendanceStatus == null) {
      return false;
    }

    final attendance = AttendanceInfo(
      studentId: studentIdController.text.trim(),
      studentName: studentNameController.text.trim(),
      class1: classController.text.trim(),
      section: sectionController.text.trim(),
      attendanceDate: attendanceDate!.toIso8601String(),
      attendanceStatus: attendanceStatus!,
    );

    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    if (baseUrl.isEmpty) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/takeattendance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(attendance.toJson()),
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        resetForm();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Error submitting attendance: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
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

// AttendanceInfo model class
class AttendanceInfo {
  final String studentId;
  final String studentName;
  final String class1;
  final String section;
  final String attendanceDate;
  final String attendanceStatus;

  AttendanceInfo({
    required this.studentId,
    required this.studentName,
    required this.class1,
    required this.section,
    required this.attendanceDate,
    required this.attendanceStatus,
  });

  factory AttendanceInfo.fromJson(Map<String, dynamic> json) => AttendanceInfo(
        studentId: json['studentId'] ?? '',
        studentName: json['studentName'] ?? '',
        class1: json['class1'] ?? '',
        section: json['section'] ?? '',
        attendanceDate: json['attendanceDate'] ?? '',
        attendanceStatus: json['attendanceStatus'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'studentName': studentName,
        'class1': class1,
        'section': section,
        'attendanceDate': attendanceDate,
        'attendanceStatus': attendanceStatus,
      };
}
