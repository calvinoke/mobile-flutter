import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  String? _username;
  String? _email;

  String? get username => _username;
  String? get email => _email;

  void setUser({required String username, required String email}) {
    _username = username;
    _email = email;
    notifyListeners();
  }

  void clearUser() {
    _username = null;
    _email = null;
    notifyListeners();
  }

  Future<bool> signup({required String username, required String email, required String password}) async {
    final apiUrl = dotenv.env['API_BASE_URL'];
    if (apiUrl == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setUser(username: data['username'], email: data['email']);
        return true;
      } else {
        debugPrint('Signup failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error during signup: $e');
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
  final apiUrl = dotenv.env['API_URL'];
  if (apiUrl == null) return false;

  try {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = Alluser.fromJson(data);
      _user = user;
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

}
