// lib/providers/student_profile_provider.dart
import 'package:flutter/material.dart';

class StudentProfileProvider with ChangeNotifier {
  String _name = '';
  String _email = '';
  String? _imageUrl;

  String get name => _name;
  String get email => _email;
  String? get imageUrl => _imageUrl;

  void setProfile({
    required String name,
    required String email,
    String? imageUrl,
  }) {
    _name = name;
    _email = email;
    _imageUrl = imageUrl;
    notifyListeners();
  }

  void clearProfile() {
    _name = '';
    _email = '';
    _imageUrl = null;
    notifyListeners();
  }
}
