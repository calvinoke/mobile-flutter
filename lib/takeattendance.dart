//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:school_management/model_class/ipAddress.dart';
//
// class TakeAttendance extends StatefulWidget {
//   @override
//   _TakeAttendanceState createState() => _TakeAttendanceState();
// }
//
// class _TakeAttendanceState extends State<TakeAttendance> {
//   final TextEditingController studentIdController = TextEditingController();
//   final TextEditingController studentNameController = TextEditingController();
//   final TextEditingController classController = TextEditingController();
//   final TextEditingController sectionController = TextEditingController();
//   DateTime? attendanceDate;
//   String? attendanceStatus;
//
//   void studentIdChanged() {
//     String studentId = studentIdController.text;
//
//     // Mock data - replace with actual API call
//     final Map<String, Map<String, String>> _studentData = {
//       '101': {'name': 'Habibur Rahman', 'class': '1st', 'section': 'A'},
//       '105': {'name': 'Obaidul Qader', 'class': '5th', 'section': 'B'},
//       '106': {'name': 'Azizur Rahman', 'class': '6th', 'section': 'C'},
//       '108': {'name': 'Sazid Mahmud', 'class': '8th', 'section': 'A'},
//       '109': {'name': 'Tanzila Rahman', 'class': '9th', 'section': 'Science'},
//       '110': {'name': 'Shahadat', 'class': '10th', 'section': 'Science'},
//     };
//
//     if (_studentData.containsKey(studentId)) {
//       setState(() {
//         studentNameController.text = _studentData[studentId]!['name']!;
//         classController.text = _studentData[studentId]!['class']!;
//         sectionController.text = _studentData[studentId]!['section']!;
//       });
//     } else {
//       setState(() {
//         studentNameController.clear();
//         classController.clear();
//         sectionController.clear();
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No student found with ID $studentId')),
//       );
//     }
//   }
//
//   Future<void> pickDateTime() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (pickedDate != null) {
//       TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//
//       if (pickedTime != null) {
//         final pickedDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//
//         setState(() {
//           attendanceDate = pickedDateTime;
//         });
//       }
//     }
//   }
//
//   void takeAttendance() async {
//     if (attendanceDate == null || attendanceStatus == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select both a date and an attendance status.')),
//       );
//       return;
//     }
//
//     AttendanceInfo attendance = AttendanceInfo(
//       studentId: studentIdController.text,
//       studentName: studentNameController.text,
//       class1: classController.text,
//       section: sectionController.text,
//       attendanceDate: attendanceDate!.toIso8601String(),
//       attendanceStatus: attendanceStatus!,
//     );
//
//     Ip ip = Ip();
//     var response = await http.post(
//       Uri.parse(ip.ipAddress + '/takeattendance'),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(attendance.toJson()),
//     );
//
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Attendance submitted successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to submit attendance')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Take Attendance'),
//         backgroundColor: Colors.teal.shade700,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16.0),
//             ),
//             elevation: 8.0,
//             shadowColor: Colors.teal.shade100,
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Student Information',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal.shade700,
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.teal.shade700,
//                     thickness: 2,
//                   ),
//                   SizedBox(height: 16),
//                   buildTextField('Student ID', 'Enter Student ID', studentIdController, onChanged: (value) => studentIdChanged()),
//                   SizedBox(height: 16),
//                   buildTextField('Student Name', 'Student Name', studentNameController, enabled: false),
//                   SizedBox(height: 16),
//                   buildTextField('Class', 'Class', classController, enabled: false),
//                   SizedBox(height: 16),
//                   buildTextField('Section', 'Section', sectionController, enabled: false),
//                   SizedBox(height: 16),
//                   Text(
//                     'Attendance',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal.shade700,
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.teal.shade700,
//                     thickness: 2,
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Attendance Date & Time:',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal.shade700),
//                   ),
//                   InkWell(
//                     onTap: pickDateTime,
//                     child: InputDecorator(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         labelText: attendanceDate != null
//                             ? "${attendanceDate!.toLocal()}".split(' ')[0] +
//                             " ${attendanceDate!.hour}:${attendanceDate!.minute.toString().padLeft(2, '0')} ${attendanceDate!.hour >= 12 ? 'PM' : 'AM'}"
//                             : 'Select Date & Time',
//                       ),
//                       child: attendanceDate == null
//                           ? Text('No date and time chosen')
//                           : Text("${attendanceDate!.toLocal()}".split(' ')[0] +
//                           " ${attendanceDate!.hour}:${attendanceDate!.minute.toString().padLeft(2, '0')} ${attendanceDate!.hour >= 12 ? 'PM' : 'AM'}"),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Attendance Status:',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal.shade700),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: RadioListTile(
//                           title: Text('Present'),
//                           value: 'present',
//                           groupValue: attendanceStatus,
//                           activeColor: Colors.teal.shade700,
//                           onChanged: (value) {
//                             setState(() {
//                               attendanceStatus = value as String?;
//                             });
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         child: RadioListTile(
//                           title: Text('Absent'),
//                           value: 'absent',
//                           groupValue: attendanceStatus,
//                           activeColor: Colors.teal.shade700,
//                           onChanged: (value) {
//                             setState(() {
//                               attendanceStatus = value as String?;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: takeAttendance,
//                       child: Text('Save Attendance'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.teal.shade50,
//                         padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                         textStyle: TextStyle(fontSize: 18),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTextField(String labelText, String hintText, TextEditingController controller, {bool enabled = true, Function(String)? onChanged}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           labelText,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal.shade700),
//         ),
//         SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           onChanged: onChanged,
//           enabled: enabled,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             hintText: hintText,
//             filled: true,
//             fillColor: enabled ? Colors.white : Colors.grey.shade200,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class AttendanceInfo {
//   final String studentId;
//   final String studentName;
//   final String class1;
//   final String section;
//   final String attendanceDate;
//   final String attendanceStatus;
//
//   AttendanceInfo({
//     required this.studentId,
//     required this.studentName,
//     required this.class1,
//     required this.section,
//     required this.attendanceDate,
//     required this.attendanceStatus,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'studentId': studentId,
//     'studentName': studentName,
//     'class1': class1,
//     'section': section,
//     'attendanceDate': attendanceDate,
//     'attendanceStatus': attendanceStatus,
//   };
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:school_management/model_class/ipAddress.dart';

class TakeAttendance extends StatefulWidget {
  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  DateTime? attendanceDate;
  String? attendanceStatus;

  void studentIdChanged() {
    String studentId = studentIdController.text;

    // Mock data - replace with actual API call
    final Map<String, Map<String, String>> _studentData = {
      '101': {'name': 'Habibur Rahman', 'class': '1st', 'section': 'A'},
      '105': {'name': 'Obaidul Qader', 'class': '5th', 'section': 'B'},
      '106': {'name': 'Azizur Rahman', 'class': '6th', 'section': 'C'},
      '108': {'name': 'Sazid Mahmud', 'class': '8th', 'section': 'A'},
      '109': {'name': 'Tanzila Rahman', 'class': '9th', 'section': 'Science'},
      '110': {'name': 'Shahadat', 'class': '10th', 'section': 'Science'},
    };

    if (_studentData.containsKey(studentId)) {
      setState(() {
        studentNameController.text = _studentData[studentId]!['name']!;
        classController.text = _studentData[studentId]!['class']!;
        sectionController.text = _studentData[studentId]!['section']!;
      });
    } else {
      setState(() {
        studentNameController.clear();
        classController.clear();
        sectionController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No student found with ID $studentId')),
      );
    }
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        attendanceDate = pickedDate;
      });
    }
  }

  void takeAttendance() async {
    if (attendanceDate == null || attendanceStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both a date and an attendance status.')),
      );
      return;
    }

    AttendanceInfo attendance = AttendanceInfo(
      studentId: studentIdController.text,
      studentName: studentNameController.text,
      class1: classController.text,
      section: sectionController.text,
      attendanceDate: attendanceDate!.toIso8601String(),
      attendanceStatus: attendanceStatus!,
    );

    Ip ip = Ip();
    var response = await http.post(
      Uri.parse(ip.ipAddress + '/takeattendance'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(attendance.toJson()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance submitted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit attendance')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Attendance'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 8.0,
            shadowColor: Colors.teal.shade100,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  Divider(
                    color: Colors.teal.shade700,
                    thickness: 2,
                  ),
                  SizedBox(height: 16),
                  buildTextField('Student ID', 'Enter Student ID', studentIdController, onChanged: (value) => studentIdChanged()),
                  SizedBox(height: 16),
                  buildTextField('Student Name', 'Student Name', studentNameController, enabled: false),
                  SizedBox(height: 16),
                  buildTextField('Class', 'Class', classController, enabled: false),
                  SizedBox(height: 16),
                  buildTextField('Section', 'Section', sectionController, enabled: false),
                  SizedBox(height: 16),
                  Text(
                    'Attendance',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  Divider(
                    color: Colors.teal.shade700,
                    thickness: 2,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Attendance Date:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal.shade700),
                  ),
                  InkWell(
                    onTap: pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: attendanceDate != null
                            ? "${attendanceDate!.toLocal()}".split(' ')[0]
                            : 'Select Date',
                      ),
                      child: attendanceDate == null
                          ? Text('No date chosen')
                          : Text("${attendanceDate!.toLocal()}".split(' ')[0]),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Attendance Status:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal.shade700),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Text('Present'),
                          value: 'present',
                          groupValue: attendanceStatus,
                          activeColor: Colors.teal.shade700,
                          onChanged: (value) {
                            setState(() {
                              attendanceStatus = value as String?;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Text('Absent'),
                          value: 'absent',
                          groupValue: attendanceStatus,
                          activeColor: Colors.teal.shade700,
                          onChanged: (value) {
                            setState(() {
                              attendanceStatus = value as String?;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: takeAttendance,
                      child: Text('Save Attendance'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade50,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String hintText, TextEditingController controller, {bool enabled = true, Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal.shade700),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: hintText,
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}

class AttendanceInfo {
  final String studentId;
  final String studentName;
  final String class1;
  final String section;
  final String attendanceDate;
  final String attendanceStatus;

  AttendanceInfo({
    required this.studentId,
    required this.studentName,
    required this.class1,
    required this.section,
    required this.attendanceDate,
    required this.attendanceStatus,
  });

  Map<String, dynamic> toJson() => {
    'studentId': studentId,
    'studentName': studentName,
    'class1': class1,
    'section': section,
    'attendanceDate': attendanceDate,
    'attendanceStatus': attendanceStatus,
  };
}