import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/admission_form_provider.dart';
import 'package:mobile/home.dart';
import 'package:mobile/model_class/onlineadmission.dart';

class AdmissionFormScreen extends StatelessWidget {
  const AdmissionFormScreen({super.key});

  Widget buildTextField({
    required String label,
    required String keyName,
    required IconData icon,
    bool obscure = false,
    required AdmissionFormProvider formProvider,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: formProvider.controllers[keyName],
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required field' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = context.watch<AdmissionFormProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admission Form'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formProvider.formKey,
          child: Column(
            children: [
              buildTextField(
                  label: 'Registration No',
                  keyName: 'reg_no',
                  icon: Icons.assignment_ind,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Full Name',
                  keyName: 'full_name',
                  icon: Icons.person,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Date of Birth',
                  keyName: 'dob',
                  icon: Icons.cake,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Email',
                  keyName: 'email',
                  icon: Icons.email,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Mobile',
                  keyName: 'mob',
                  icon: Icons.phone,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Gender',
                  keyName: 'gender',
                  icon: Icons.wc,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Father Name',
                  keyName: 'fathername',
                  icon: Icons.person,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Mother Name',
                  keyName: 'mothername',
                  icon: Icons.person,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Class',
                  keyName: 'class1',
                  icon: Icons.class_,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Section',
                  keyName: 'section',
                  icon: Icons.account_tree,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Present Address',
                  keyName: 'present_address',
                  icon: Icons.home,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Permanent Address',
                  keyName: 'permanent_address',
                  icon: Icons.home,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Username',
                  keyName: 'username',
                  icon: Icons.account_circle,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Session',
                  keyName: 'session',
                  icon: Icons.date_range,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Password',
                  keyName: 'password',
                  icon: Icons.lock,
                  obscure: true,
                  formProvider: formProvider),
              buildTextField(
                  label: 'Image URL',
                  keyName: 'image',
                  icon: Icons.image,
                  formProvider: formProvider),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: formProvider.isLoading
                    ? null
                    : () async {
                        if (formProvider.formKey.currentState!.validate()) {
                          final result = await formProvider.submitForm();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result != null
                                    ? 'Submitted successfully'
                                    : 'Submission failed'),
                              ),
                            );
                            if (result != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyHomePage(title: 'Home'),
                                ),
                              );
                            }
                          }
                        }
                      },
                child: formProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
