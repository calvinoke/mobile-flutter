import 'package:flutter/material.dart';
import 'package:mobile/model_class/Onlineadmission.dart';
import 'package:mobile/service/admission_service.dart';

class AdmissionFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> controllers = {
    'reg_no': TextEditingController(),
    'full_name': TextEditingController(),
    'dob': TextEditingController(),
    'email': TextEditingController(),
    'mob': TextEditingController(),
    'gender': TextEditingController(),
    'fathername': TextEditingController(),
    'mothername': TextEditingController(),
    'class1': TextEditingController(),
    'section': TextEditingController(),
    'present_address': TextEditingController(),
    'permanent_address': TextEditingController(),
    'username': TextEditingController(),
    'session': TextEditingController(),
    'password': TextEditingController(),
    'image': TextEditingController(),
  };

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Onlineadmission?> submitForm() async {
    _isLoading = true;
    notifyListeners();

    final student = Onlineadmission(
      regNo: int.tryParse(controllers['reg_no']!.text),
      fullName: controllers['full_name']!.text,
      dob: DateTime.tryParse(controllers['dob']!.text) ?? DateTime(2000, 1, 1),
      email: controllers['email']!.text,
      mobile: controllers['mob']!.text,
      gender: controllers['gender']!.text,
      fatherName: controllers['fathername']!.text,
      motherName: controllers['mothername']!.text,
      className: controllers['class1']!.text,
      section: controllers['section']!.text,
      presentAddress: controllers['present_address']!.text,
      permanentAddress: controllers['permanent_address']!.text,
      session: controllers['session']!.text,
      username: controllers['username']!.text,
      password: controllers['password']!.text,
      image: controllers['image']!.text.isNotEmpty
          ? controllers['image']!.text
          : null,
    );

    try {
      final result = await AdmissionService.submitForm(student);
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void disposeControllers() {
    for (final c in controllers.values) {
      c.dispose();
    }
  }
}
