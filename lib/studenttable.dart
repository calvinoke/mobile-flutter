

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:school_management/adminpanel.dart';
import 'package:school_management/model_class/ipAddress.dart';

class Studenttable extends StatefulWidget {
  const Studenttable({super.key});

  @override
  State<Studenttable> createState() => _StudenttableState();
}

class _StudenttableState extends State<Studenttable> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _student_id = TextEditingController();
  TextEditingController _full_name = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mob = TextEditingController();
  TextEditingController _class1 = TextEditingController();
  TextEditingController _subject = TextEditingController();
  TextEditingController _present_addres = TextEditingController();
  TextEditingController _permanent_address = TextEditingController();
  TextEditingController _session = TextEditingController();
  TextEditingController _status = TextEditingController();
  TextEditingController _section = TextEditingController();

  String _selectedGender = 'Male'; // Default value

  Future<void> applyforaccount() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        'student_id': int.parse(_student_id.text),
        'full_name': _full_name.text,
        'dob': _dob.text,
        'email': _email.text,
        'mob': _mob.text,
        'gender': _selectedGender,
        'class1': _class1.text,
        'subject': _subject.text,
        'present_address': _present_addres.text,
        'permanent_address': _permanent_address.text,
        'session': _session.text,
        'status': _status.text,
        'section': _section.text,
      };

      Ip ip = Ip();
      final response = await http.post(
        Uri.parse(ip.ipAddress + '/allstudent'),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Response = jsonDecode(response.body);
        // Handle response data as needed
      } else {
        throw Exception("Error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Student"),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey, // Associate the form key with the form
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildTextField(
                  _student_id,
                  'Student ID',
                  Icons.assignment_ind,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a student ID';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  _full_name,
                  'Full Name',
                  Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a full name';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  _dob,
                  'Date of Birth',
                  Icons.cake,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date of birth';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  _email,
                  'Email',
                  Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  _mob,
                  'Mobile Number',
                  Icons.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a mobile number';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit number';
                    }
                    return null;
                  },
                ),
                buildGenderDropdown(),
                buildTextField(
                  _class1,
                  'Class',
                  Icons.class_,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a class';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  _subject,
                  'Subject',
                  Icons.book,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  _present_addres,
                  'Present Address',
                  Icons.home,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a present address';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  _permanent_address,
                  'Permanent Address',
                  Icons.location_city,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a permanent address';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  _session,
                  'Session',
                  Icons.date_range,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a session';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  _status,
                  'Status',
                  Icons.verified_user,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a status';
                    }
                    return null;
                  },
                ),
                buildTextField(
                  _section,
                  'Section',
                  Icons.account_tree,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a section';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Add Student', style: TextStyle(fontSize: 18)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, process the data
                      await applyforaccount();
                      SnackBar snk = SnackBar(content: Text('Added successfully'));
                      ScaffoldMessenger.of(context).showSnackBar(snk);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Adminpanel()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: validator, // Add validator here
      ),
    );
  }

  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: 'Gender',
          prefixIcon: Icon(Icons.wc, color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        items: ['Male', 'Female', 'Other']
            .map((gender) => DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value!;
          });
        },
      ),
    );
  }
}
