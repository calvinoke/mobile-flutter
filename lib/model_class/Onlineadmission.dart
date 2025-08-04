import 'dart:convert';

/// Represents an online admission form submitted by a student.
class Onlineadmission {
  final int? regNo;
  final String fullName;
  final DateTime dob;
  final String email;
  final String mobile;
  final String gender;
  final String fatherName;
  final String motherName;
  final String className;
  final String section;
  final String presentAddress;
  final String permanentAddress;
  final String session;
  final String username;

  ///WARNING: Avoid storing passwords in plain text. This should be encrypted or hashed server-side.
  final String password;

  /// Could be a URL, base64 string, or used for file uploads (depending on use case)
  final String? image;

  Onlineadmission({
    required this.regNo,
    required this.fullName,
    required this.dob,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.fatherName,
    required this.motherName,
    required this.className,
    required this.section,
    required this.presentAddress,
    required this.permanentAddress,
    required this.session,
    required this.username,
    required this.password,
    this.image,
  });

  /// Factory constructor to create an instance from JSON data.
  factory Onlineadmission.fromJson(Map<String, dynamic> json) {
    return Onlineadmission(
      regNo: json['reg_no'],
      fullName: json['full_name'] ?? '',
      dob: DateTime.tryParse(json['dob'] ?? '') ?? DateTime(2000, 1, 1),
      email: json['email'] ?? '',
      mobile: json['mob'] ?? '',
      gender: json['gender'] ?? '',
      fatherName: json['fathername'] ?? '',
      motherName: json['mothername'] ?? '',
      className: json['class1'] ?? '',
      section: json['section'] ?? '',
      presentAddress: json['present_address'] ?? '',
      permanentAddress: json['permanent_address'] ?? '',
      session: json['session'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      image: json['image'],
    );
  }

  /// Converts the model to a JSON map
  Map<String, dynamic> toJson() => {
        'reg_no': regNo,
        'full_name': fullName,
        'dob': dob.toIso8601String(),
        'email': email,
        'mob': mobile,
        'gender': gender,
        'fathername': fatherName,
        'mothername': motherName,
        'class1': className,
        'section': section,
        'present_address': presentAddress,
        'permanent_address': permanentAddress,
        'session': session,
        'username': username,
        'password': password,
        'image': image,
      };

  /// Simple validation to check required fields (you can expand this)
  bool isValid() {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        mobile.isNotEmpty &&
        username.isNotEmpty &&
        password.length >= 6;
  }
}
