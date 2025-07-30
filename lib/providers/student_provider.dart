// lib/providers/student_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StudentProvider with ChangeNotifier {
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> get students => _students;

  bool isLoading = false;

  /// Fetch all students
  Future<void> fetchStudents() async {
    isLoading = true;
    notifyListeners();

    try {
      final apiBaseUrl = dotenv.env['API_BASE_URL'];
      if (apiBaseUrl == null || apiBaseUrl.isEmpty) {
        throw Exception('API_BASE_URL not found in .env');
      }

      final response = await http.get(Uri.parse('$apiBaseUrl/allstudent'));

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        _students = decoded.cast<Map<String, dynamic>>();
      } else {
        throw Exception("Failed to load students: ${response.statusCode}");
      }
    } catch (e) {
      _students = [];
      // Optionally log or save error state
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new student or update existing by ID
  Future<void> addOrUpdateStudent(Map<String, dynamic> student, {int? id}) async {
    final apiBaseUrl = dotenv.env['API_BASE_URL'];
    if (apiBaseUrl == null || apiBaseUrl.isEmpty) {
      throw Exception('API_BASE_URL not found in .env');
    }

    final uri = id != null
        ? Uri.parse('$apiBaseUrl/allstudent/$id')
        : Uri.parse('$apiBaseUrl/allstudent');

    final response = id != null
        ? await http.put(
            uri,
            body: jsonEncode(student),
            headers: {"Content-Type": "application/json"},
          )
        : await http.post(
            uri,
            body: jsonEncode(student),
            headers: {"Content-Type": "application/json"},
          );

    if (response.statusCode == 200) {
      await fetchStudents();
    } else {
      throw Exception('Failed to add/update student: ${response.statusCode}');
    }
  }

  /// Delete a student by ID
  Future<void> deleteStudent(int id) async {
    final apiBaseUrl = dotenv.env['API_BASE_URL'];
    if (apiBaseUrl == null || apiBaseUrl.isEmpty) {
      throw Exception('API_BASE_URL not found in .env');
    }

    final response = await http.delete(Uri.parse('$apiBaseUrl/allstudent/$id'));

    if (response.statusCode == 200) {
      // Remove locally for immediate UI update
      _students.removeWhere((s) => s['id'] == id);
      notifyListeners();
    } else {
      throw Exception("Failed to delete student: ${response.statusCode}");
    }
  }
}
