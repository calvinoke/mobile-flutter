import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/model_class/ExamSchedule.dart';

class ExamScheduleProvider with ChangeNotifier {
  List<Examschedule> _examSchedules = [];
  bool _isLoading = false;
  String? _error;

  List<Examschedule> get examSchedules => _examSchedules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchExamSchedules() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      if (baseUrl == null) {
        throw Exception('API_BASE_URL not set in .env file');
      }

      final response = await http.get(Uri.parse('$baseUrl/getexamschedule'));

      if (response.statusCode == 200) {
        _examSchedules = List<Examschedule>.from(
          json.decode(response.body).map((x) => Examschedule.fromJson(x)),
        );
      } else {
        _error = 'Failed to load exam schedule: ${response.statusCode}';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
