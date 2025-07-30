import 'dart:convert'; 
import 'dart:io'; 

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:mobile/model_class/Studenttable.dart'; 

// Stateful widget for adding or editing a student
class AddStudentScreen extends StatefulWidget {
  final Studenttable? student; 

  const AddStudentScreen({super.key, this.student});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  // Text controllers for each input field
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController mobController;
  late TextEditingController genderController;
  late TextEditingController classController;
  late TextEditingController sessionController;
  late TextEditingController sectionController;
  late TextEditingController statusController;

  File? _selectedImage; // Stores the selected image file
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  final bool uploadAsBase64 = false; // Toggle to switch upload type

  // Initializes text controllers with existing student data (if editing)
  @override
  void initState() {
    super.initState();
    final s = widget.student;
    fullNameController = TextEditingController(text: s?.full_name ?? '');
    emailController = TextEditingController(text: s?.email ?? '');
    dobController = TextEditingController(text: s?.dob ?? '');
    mobController = TextEditingController(text: s?.mob ?? '');
    genderController = TextEditingController(text: s?.gender ?? '');
    classController = TextEditingController(text: s?.class1 ?? '');
    sessionController = TextEditingController(text: s?.session ?? '');
    sectionController = TextEditingController(text: s?.section ?? '');
    statusController = TextEditingController(text: s?.status ?? '');
  }

  // Opens the gallery to pick an image
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  // Handles form submission and API request
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return; // Validate form inputs

    final isEdit = widget.student != null;
    final url = isEdit
        ? '${dotenv.env['API_BASE_URL']}/update/${widget.student!.student_id}'

        : '${dotenv.env['API_BASE_URL']}/add';

    final uri = Uri.parse(url);

    try {
      http.Response response;

      if (uploadAsBase64) {
        // Convert image to base64 string and send via JSON
        final imageBase64 = _selectedImage != null
            ? base64Encode(_selectedImage!.readAsBytesSync())
            : null;

        final studentData = {
          "full_name": fullNameController.text,
          "email": emailController.text,
          "dob": dobController.text,
          "mob": mobController.text,
          "gender": genderController.text,
          "class1": classController.text,
          "session": sessionController.text,
          "section": sectionController.text,
          "status": statusController.text,
          "image_base64": imageBase64,
        };

        response = isEdit
            ? await http.put(uri,
                headers: {'Content-Type': 'application/json'},
                body: json.encode(studentData))
            : await http.post(uri,
                headers: {'Content-Type': 'application/json'},
                body: json.encode(studentData));
      } else {
        // Send data as multipart/form-data including image file
        var request = isEdit
            ? http.MultipartRequest('PUT', uri)
            : http.MultipartRequest('POST', uri);

        // Add all text fields
        request.fields.addAll({
          "full_name": fullNameController.text,
          "email": emailController.text,
          "dob": dobController.text,
          "mob": mobController.text,
          "gender": genderController.text,
          "class1": classController.text,
          "session": sessionController.text,
          "section": sectionController.text,
          "status": statusController.text,
        });

        // Attach image file if available
        if (_selectedImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            _selectedImage!.path,
          ));
        }

        final streamed = await request.send();
        response = await http.Response.fromStream(streamed);
      }

      // Show success or error snackbar
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? "Student updated" : "Student added")),
        );
        Navigator.pop(context); // Return to previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save student: ${response.body}")),
        );
      }
    } catch (e) {
      // Show error snackbar on exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Builds a reusable text field with validation
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  // Builds the main UI of the screen
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Student' : 'Add Student')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Full Name', fullNameController),
              _buildTextField('Email', emailController),
              _buildTextField('DOB', dobController),
              _buildTextField('Mobile', mobController),
              _buildTextField('Gender', genderController),
              _buildTextField('Class', classController),
              _buildTextField('Session', sessionController),
              _buildTextField('Section', sectionController),
              _buildTextField('Status', statusController),
              const SizedBox(height: 12),

              // Image picker area
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? const Center(child: Text('Tap to select image'))
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(isEdit ? 'Update Student' : 'Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
