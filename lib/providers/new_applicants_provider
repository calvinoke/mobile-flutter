import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/model_class/Onlineadmission.dart';

class NewApplicantsProvider with ChangeNotifier {
  List<Onlineadmission> _students = [];
  String? _error;
  bool _isLoading = false;

  List<Onlineadmission> get students => _students;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> fetchStudents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final apiUrl = dotenv.env['API_URL'];

    if (apiUrl == null) {
      _error = "API_URL is not defined";
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(Uri.parse('$apiUrl/newapplicant'));

      if (response.statusCode == 200) {
        _students = List<Onlineadmission>.from(
            json.decode(response.body).map((x) => Onlineadmission.fromJson(x)));
      } else {
        _error = 'Failed to load students';
      }
    } catch (e) {
      _error = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
