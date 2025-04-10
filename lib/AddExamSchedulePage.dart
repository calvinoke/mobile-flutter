// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:school_management/adminpanel.dart';
// import 'package:school_management/model_class/ExamSchedule.dart';
// import 'package:school_management/model_class/ipAddress.dart';
//
// List<Examschedule> objectsFromJson(String str) =>
//     List<Examschedule>.from(json.decode(str).map((x) => Examschedule.fromJson(x)));
// String objectsToJson(List<Examschedule> data) =>
//     json.encode(List<Examschedule>.from(data).map((x) => x.toJson()));
//
// class AddExamSchedulePage extends StatefulWidget {
//   const AddExamSchedulePage({super.key});
//
//   @override
//   State<AddExamSchedulePage> createState() => _AddExamSchedulePageState();
// }
//
// class _AddExamSchedulePageState extends State<AddExamSchedulePage> {
//   // Define controllers for form fields
//   final TextEditingController _examIdController = TextEditingController();
//
//   final TextEditingController _examTitleController = TextEditingController();
//   final TextEditingController _classController = TextEditingController();
//   final TextEditingController _subjectController = TextEditingController();
//   final TextEditingController _examTypeController = TextEditingController();
//   final TextEditingController _examHallController = TextEditingController();
//   final TextEditingController _examStartController = TextEditingController();
//   final TextEditingController _examEndController = TextEditingController();
//   final TextEditingController _examInvigilatorController = TextEditingController();
//   final TextEditingController _examDateController = TextEditingController();
//
//   Future<Examschedule?> _sendExamSchedule() async {
//     Examschedule s = Examschedule(
//       examTitle: _examTitleController.text,
//       class1: _classController.text,
//       subject: _subjectController.text,
//       examType: _examTypeController.text,
//       examHall: _examHallController.text,
//       examStart: _examStartController.text,
//       examEnd: _examEndController.text,
//       examInvigilator: _examInvigilatorController.text,
//       examDate: _examDateController.text,
//     );
//
//     Ip ip = Ip();
//     try {
//       final response = await http.post(
//         Uri.parse('${ip.ipAddress}/examschedule'),
//         body: jsonEncode(s.toJson()),
//         headers: {"Content-Type": "application/json"},
//       );
//
//       if (response.statusCode == 200) {
//         return Examschedule.fromJson(jsonDecode(response.body));
//       } else {
//         print("Failed to add exam schedule. Status code: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("Error sending exam schedule: $e");
//       return null;
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (pickedDate != null) {
//       setState(() {
//         _examDateController.text = pickedDate.toLocal().toString().split(' ')[0];
//       });
//     }
//   }
//
//   Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//
//     if (pickedTime != null) {
//       setState(() {
//         controller.text = pickedTime.format(context);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Exam Schedule'),
//       ),
//       body: Form(
//         child: Padding(
//           padding: EdgeInsets.all(10),
//           child: ListView(
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: TextFormField(
//                   controller: _examTitleController,
//                   decoration: InputDecoration(
//                     labelText: 'Exam Title',
//                     prefixIcon: Icon(Icons.book, color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Please enter the exam title' : null,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: TextFormField(
//                   controller: _classController,
//                   decoration: InputDecoration(
//                     labelText: 'Class',
//                     prefixIcon: Icon(Icons.class_, color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Please enter the class' : null,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: TextFormField(
//                   controller: _subjectController,
//                   decoration: InputDecoration(
//                     labelText: 'Subject',
//                     prefixIcon: Icon(Icons.subject, color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Please enter the subject' : null,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: TextFormField(
//                   controller: _examTypeController,
//                   decoration: InputDecoration(
//                     labelText: 'Exam Type',
//                     prefixIcon: Icon(Icons.description, color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Please enter the exam type' : null,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: TextFormField(
//                   controller: _examHallController,
//                   decoration: InputDecoration(
//                     labelText: 'Exam Hall',
//                     prefixIcon: Icon(Icons.location_on, color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Please enter the exam hall' : null,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: TextFormField(
//                   controller: _examStartController,
//                   decoration: InputDecoration(
//                     labelText: 'Start Time',
//                     prefixIcon: Icon(Icons.access_time, color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                   ),
//                   readOnly: true,
//                   onTap: () => _selectTime(context, _examStartController),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: TextFormField(
//                   controller: _examEndController,
//                   decoration: InputDecoration(
//                     labelText: 'End Time',
//                     prefixIcon: Icon(Icons.access_time, color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                   ),
//                   readOnly: true,
//                   onTap: () => _selectTime(context, _examEndController),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: TextFormField(
//                   controller: _examInvigilatorController,
//                   decoration: InputDecoration(
//                     labelText: 'Invigilator',
//                     prefixIcon: Icon(Icons.person, color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                   ),
//                   validator: (value) => value!.isEmpty ? 'Please enter the invigilator' : null,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(5),
//                 child: TextFormField(
//                   controller: _examDateController,
//                   decoration: InputDecoration(
//                     labelText: 'Exam Date',
//                     prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                   ),
//                   readOnly: true,
//                   onTap: () => _selectDate(context),
//                 ),
//               ),
//               ElevatedButton(
//                 child: Text('Add Exam Schedule'),
//                 onPressed: () async {
//                   if (_examTitleController.text.isEmpty ||
//                       _classController.text.isEmpty ||
//                       _subjectController.text.isEmpty ||
//                       _examTypeController.text.isEmpty ||
//                       _examHallController.text.isEmpty ||
//                       _examStartController.text.isEmpty ||
//                       _examEndController.text.isEmpty ||
//                       _examInvigilatorController.text.isEmpty ||
//                       _examDateController.text.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Please fill all fields')),
//                     );
//                     return;
//                   }
//
//                   Examschedule? newExamSchedule = await _sendExamSchedule();
//
//                   if (newExamSchedule != null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Exam schedule added successfully')),
//                     );
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Adminpanel()),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Failed to add exam schedule')),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AddExamSchedulePage extends StatefulWidget {
  @override
  _AddExamSchedulePageState createState() => _AddExamSchedulePageState();
}

class _AddExamSchedulePageState extends State<AddExamSchedulePage> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String examTitle = '';
  String selectedClass = '';
  String selectedSection = '';
  String selectedSubject = '';
  String examType = '';
  String examHall = '';
  DateTime? examDate;
  TimeOfDay? examStartTime;
  TimeOfDay? examEndTime;
  String selectedInvigilator = '';

  List<String> subjectList = [];
  List<String> allTeacherNameList = ['Afsana Meem Ema ', 'Sajeeb Islam', 'Jahir Uddin'];

  void _saveExamSchedule() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exam Schedule has been set successfully!')),
      );
    }
  }

  void getSubjectList() {
    setState(() {
      if (selectedClass == '9th' || selectedClass == '10th') {
        subjectList = ['Math', 'Physics', 'Chemistry','Accounting', 'Finance'];
      } else {
        subjectList = ['Bangla', 'English', 'Math','Science'];
      }
    });
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != examDate) {
      setState(() {
        examDate = picked;
      });
    }
  }

  Future<void> _pickTime({required bool isStartTime}) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          examStartTime = picked;
        } else {
          examEndTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exam Schedule'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Exam Title', (value) {
                examTitle = value ?? '';
              }),
              _buildDropdown(
                label: 'Class',
                value: selectedClass,
                items: [
                  '1st', '2nd', '3rd', '4th', '5th',
                  '6th', '7th', '8th', '9th', '10th'
                ],
                onChanged: (value) {
                  setState(() {
                    selectedClass = value ?? '';
                    getSubjectList();
                  });
                },
              ),
              if (selectedClass == '9th' || selectedClass == '10th')
                _buildDropdown(
                  label: 'Section',
                  value: selectedSection,
                  items: ['Science', 'Business Studies', 'Huminities'],
                  onChanged: (value) {
                    setState(() {
                      selectedSection = value ?? '';
                      getSubjectList();
                    });
                  },
                ),
              _buildDropdown(
                label: 'Subject',
                value: selectedSubject,
                items: subjectList,
                onChanged: (value) {
                  setState(() {
                    selectedSubject = value ?? '';
                  });
                },
              ),
              _buildDropdown(
                label: 'Exam Type',
                value: examType,
                items: ['Theory', 'Practical'],
                onChanged: (value) {
                  setState(() {
                    examType = value ?? '';
                  });
                },
              ),
              _buildTextField('Examination Hall', (value) {
                examHall = value ?? '';
              }),
              _buildDateTimePicker(
                label: 'Exam Date',
                value: examDate == null
                    ? 'Pick Exam Date'
                    : 'Exam Date: ${examDate!.toLocal()}'.split(' ')[0],
                onTap: _pickDate,
              ),
              _buildDateTimePicker(
                label: 'Exam Start Time',
                value: examStartTime == null
                    ? 'Pick Exam Start Time'
                    : 'Exam Start Time: ${examStartTime!.format(context)}',
                onTap: () => _pickTime(isStartTime: true),
              ),
              _buildDateTimePicker(
                label: 'Exam End Time',
                value: examEndTime == null
                    ? 'Pick Exam End Time'
                    : 'Exam End Time: ${examEndTime!.format(context)}',
                onTap: () => _pickTime(isStartTime: false),
              ),
              _buildDropdown(
                label: 'Exam Invigilator',
                value: selectedInvigilator,
                items: allTeacherNameList,
                onChanged: (value) {
                  setState(() {
                    selectedInvigilator = value ?? '';
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExamSchedule,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  textStyle: TextStyle(fontSize: 16),
                  foregroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Set Exam Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onSaved: onSaved,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(value),
        trailing: Icon(Icons.calendar_today),
        onTap: onTap,
        tileColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}

