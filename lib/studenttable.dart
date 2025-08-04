// lib/screens/student_table.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/student_provider.dart';
import 'package:mobile/model_class/Studenttable.dart';

class StudentTable extends StatefulWidget {
  const StudentTable({super.key});

  @override
  State<StudentTable> createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _studentId = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _class = TextEditingController();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _presentAddress = TextEditingController();
  final TextEditingController _permanentAddress = TextEditingController();
  final TextEditingController _session = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final TextEditingController _section = TextEditingController();

  String _selectedGender = 'Male';
  int? _editingId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<StudentProvider>(context, listen: false).fetchStudents());
  }

  Studenttable _buildStudentData() {
    return Studenttable(
      student_id: _studentId.text.isEmpty ? null : int.tryParse(_studentId.text),
      full_name: _fullName.text,
      dob: _dob.text,
      email: _email.text,
      mob: _mobile.text,
      gender: _selectedGender,
      class1: _class.text,
      subject: _subject.text,
      present_address: _presentAddress.text,
      permanent_address: _permanentAddress.text,
      session: _session.text,
      status: _status.text,
      section: _section.text,
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _studentId.clear();
    _fullName.clear();
    _dob.clear();
    _email.clear();
    _mobile.clear();
    _class.clear();
    _subject.clear();
    _presentAddress.clear();
    _permanentAddress.clear();
    _session.clear();
    _status.clear();
    _section.clear();
    _selectedGender = 'Male';
    _editingId = null;
  }

  void _populateForm(Studenttable student) {
    setState(() {
      _editingId = student.student_id;
      _studentId.text = student.student_id?.toString() ?? '';
      _fullName.text = student.full_name ?? '';
      _dob.text = student.dob ?? '';
      _email.text = student.email ?? '';
      _mobile.text = student.mob ?? '';
      _selectedGender = student.gender ?? 'Male';
      _class.text = student.class1 ?? '';
      _subject.text = student.subject ?? '';
      _presentAddress.text = student.present_address ?? '';
      _permanentAddress.text = student.permanent_address ?? '';
      _session.text = student.session ?? '';
      _status.text = student.status ?? '';
      _section.text = student.section ?? '';
    });
  }

  Future<void> _submitStudent(StudentProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await provider.addOrUpdateStudent(_buildStudentData(), id: _editingId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_editingId == null ? 'Student added' : 'Student updated')),
      );
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Student Management"), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TODO: Add your TextFormFields here for each controller, e.g.
              // TextFormField(controller: _fullName, decoration: InputDecoration(labelText: 'Full Name'), validator: ...),

              ElevatedButton(
                onPressed: () => _submitStudent(provider),
                child: Text(_editingId == null ? 'Add Student' : 'Update Student'),
              ),
              const SizedBox(height: 30),
              const Text('All Students', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: provider.students
                          .map(
                            (Studenttable student) => ListTile(
                              title: Text(student.full_name ?? ''),
                              subtitle: Text("Class: ${student.class1 ?? ''}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () => _populateForm(student),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      if (student.student_id != null) {
                                        await provider.deleteStudent(student.student_id!);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Student deleted")));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
