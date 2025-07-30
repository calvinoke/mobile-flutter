import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/model_class/Onlineadmission.dart';

class AdmissionService {
  static Future<Onlineadmission?> submitForm(Onlineadmission student) async {
    final String? baseUrl = dotenv.env['API_URL'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('API_URL is not set in .env file');
    }

    final url = Uri.parse('$baseUrl/form');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(student.toJson()),
      );

      if (response.statusCode == 200) {
        return Onlineadmission.fromJson(jsonDecode(response.body));
      } else {
        print('Server error: ${response.statusCode}');
        print('Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Submission error: $e');
      return null;
    }
  }
}
