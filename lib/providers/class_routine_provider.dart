import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/model_class/Classroutine.dart';

class ClassRoutineProvider extends ChangeNotifier {
  List<Classroutine> _routines = [];
  bool _isLoading = false;
  String? _error;

  List<Classroutine> get routines => _routines;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRoutinesByClass(String className) async {
    if (className.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final baseUrl = dotenv.env['API_BASE_URL'];
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('API_BASE_URL not found in .env');
      }

      final response = await http.get(Uri.parse('$baseUrl/searchstudentroutine/$className'));

      if (response.statusCode == 200) {
        _routines = List<Classroutine>.from(
          json.decode(response.body).map((x) => Classroutine.fromJson(x)),
        );
      } else {
        _error = 'Failed to load data: ${response.statusCode}';
        _routines = [];
      }
    } catch (e) {
      _error = e.toString();
      _routines = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
