// lib/providers/student_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model_class/Studenttable.dart';

class StudentProvider with ChangeNotifier {
  List<Studenttable> _students = [];
  String _searchQuery = '';
  String _selectedClass = 'All';

  bool isLoading = false;

  List<Studenttable> get students => _students;

  List<String> get classes => ['All', '1', '2', '3', '4', '5'];
  String get selectedClass => _selectedClass;

  List<Studenttable> get filteredStudents {
    return _students.where((student) {
      final nameMatch = student.full_name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
      final classMatch = _selectedClass == 'All' || student.class1 == _selectedClass;
      return nameMatch && classMatch;
    }).toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSelectedClass(String selected) {
    _selectedClass = selected;
    notifyListeners();
  }

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
        _students = decoded.map((e) => Studenttable.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load students: ${response.statusCode}");
      }
    } catch (e) {
      _students = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrUpdateStudent(Studenttable student, {int? id}) async {
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
            body: jsonEncode(student.toJson()),
            headers: {"Content-Type": "application/json"},
          )
        : await http.post(
            uri,
            body: jsonEncode(student.toJson()),
            headers: {"Content-Type": "application/json"},
          );

    if (response.statusCode == 200) {
      await fetchStudents();
    } else {
      throw Exception('Failed to add/update student: ${response.statusCode}');
    }
  }

  Future<bool> deleteStudent(int id) async {
    try {
      final apiBaseUrl = dotenv.env['API_BASE_URL'];
      if (apiBaseUrl == null || apiBaseUrl.isEmpty) {
        throw Exception('API_BASE_URL not found in .env');
      }

      final response = await http.delete(Uri.parse('$apiBaseUrl/allstudent/$id'));

      if (response.statusCode == 200) {
        _students.removeWhere((student) => student.id == id);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
