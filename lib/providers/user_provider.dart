import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:mobile/model_class/Alluser.dart';
import 'package:mobile/model_class/teacher_dashboard.dart';
import 'package:mobile/model_class/onlineadmission.dart'; 
import 'package:mobile/service/api_service.dart';

class UserProvider with ChangeNotifier {
  Alluser? _user;
  TeacherDashboard dashboard = TeacherDashboard(courses: [], students: []);
  String? _token;

  // Add Onlineadmission student field
  Onlineadmission? _student;

  // Getters
  Alluser? get user => _user;
  String? get token => _token;
  Onlineadmission? get student => _student;

  UserProvider() {
    _loadUserFromPrefs();
  }

  // Setter for student
  void setStudent(Onlineadmission student) {
    _student = student;
    notifyListeners();
  }

  void setUser({
    required String username,
    required String email,
    String name = '',
    String image = '',
    String role = '',
    String password = '',
    String token = '',
  }) {
    _user = Alluser(
      username: username,
      email: email,
      name: name,
      image: image,
      role: role,
      password: password,
      token: token,
    );
    notifyListeners();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken');

    final userJson = prefs.getString('userData');
    if (userJson != null) _user = Alluser.fromJson(jsonDecode(userJson));

    final dashboardJson = prefs.getString('dashboardData');
    if (dashboardJson != null) {
      dashboard = TeacherDashboard.fromJson(jsonDecode(dashboardJson));
    }

    // Optionally, you could also load _student from prefs here if you save it

    notifyListeners();
  }

  Future<void> _saveSession(String token, Alluser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setString('userData', jsonEncode(user.toJson()));

    // Optionally, save _student here if needed
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userData');
    await prefs.remove('dashboardData');
    _token = null;
    clearUser();
  }

  void clearUser() {
    _user = null;
    dashboard = TeacherDashboard(courses: [], students: []);
    _student = null;  // Clear student on logout
    notifyListeners();
  }

  Future<Alluser?> signup(Alluser newUser) async {
    final apiUrl = dotenv.env['API_BASE_URL'];
    if (apiUrl == null) return null;

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newUser.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final createdUser = Alluser.fromJson(data);
        _user = createdUser;
        notifyListeners();
        return createdUser;
      } else {
        debugPrint('Signup failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error during signup: $e');
      return null;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    final apiUrl = dotenv.env['API_BASE_URL'];
    if (apiUrl == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = Alluser.fromJson(data['user']);

        _user = user;
        _token = token;
        await _saveSession(token, user);
        notifyListeners();
        return true;
      } else {
        debugPrint('Login failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<void> fetchTeacherDashboard() async {
    try {
      final result = await ApiService.fetchDashboardData(token: _token);
      dashboard = TeacherDashboard.fromJson(result);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('dashboardData', jsonEncode(result));

      notifyListeners();
    } catch (e) {
      if (e.toString().contains('401')) {
        await logout();
        debugPrint("Session expired. Logging out.");
      } else {
        debugPrint("Error fetching dashboard: $e");
      }
    }
  }

  Future<void> generatePrintablePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Report Card',
                  style:
                      pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Name: ${_user?.name ?? "N/A"}'),
              pw.Text('Email: ${_user?.email ?? "N/A"}'),
              pw.SizedBox(height: 12),
              pw.Text('Courses:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...dashboard.courses.map((course) => pw.Text('- ${course.name}')),
              pw.SizedBox(height: 12),
              pw.Text('Students:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...dashboard.students
                  .map((student) => pw.Text('- ${student.name} (${student.email})')),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
