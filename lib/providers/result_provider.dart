// lib/providers/result_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ResultProvider with ChangeNotifier {
  Map<String, dynamic>? resultData;
  String? errorMessage;
  bool isLoading = false;

  String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _handleResponse(http.Response response, String action) {
    _setLoading(false);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      resultData = response.body.isNotEmpty ? json.decode(response.body) : {'message': 'Result $action successfully'};
      errorMessage = null;
    } else {
      errorMessage = 'Failed to $action result: ${response.body}';
      resultData = null;
    }
    notifyListeners();
  }

  Future<void> createResult({required int studentId, required String class1, required int score}) async {
    _setLoading(true);
    final response = await http.post(
      Uri.parse('$baseUrl/results'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'student_id': studentId,
        'class1': class1,
        'score': score,
        'Result': 'Pass',
      }),
    );
    _handleResponse(response, 'created');
  }

  Future<void> getResult({required String studentId, required String class1}) async {
    _setLoading(true);
    final response = await http.get(
      Uri.parse('$baseUrl/results?studentId=$studentId&class=$class1'),
    );
    _handleResponse(response, 'fetched');
  }

  Future<void> updateResult({required String id, required int score}) async {
    _setLoading(true);
    final response = await http.put(
      Uri.parse('$baseUrl/results/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'score': score, 'Result': 'Pass'}),
    );
    _handleResponse(response, 'updated');
  }

  Future<void> deleteResult({required String id}) async {
    _setLoading(true);
    final response = await http.delete(Uri.parse('$baseUrl/results/$id'));
    _handleResponse(response, 'deleted');
  }
}
