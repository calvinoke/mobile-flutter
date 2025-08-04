import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager extends ChangeNotifier {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  SessionManager._internal() {
    _loadLoginStatus();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedIn = prefs.containsKey('auth_token');
    notifyListeners();
  }

  Future<void> set(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    if (key == 'auth_token') {
      _loggedIn = true;
      notifyListeners();
    }
  }

  Future<String?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _loggedIn = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await clear();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }
}

