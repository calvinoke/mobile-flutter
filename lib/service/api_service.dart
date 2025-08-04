import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static Future<Map<String, dynamic>> fetchDashboardData({String? token}) async {
    final apiUrl = dotenv.env['API_BASE_URL'];
    if (apiUrl == null) {
      throw Exception('API_BASE_URL not set in .env file');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/dashboard'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Token might be expired
      throw Exception('Unauthorized - token may be expired');
    } else {
      throw Exception('Failed to load dashboard: ${response.statusCode}');
    }
  }
}
