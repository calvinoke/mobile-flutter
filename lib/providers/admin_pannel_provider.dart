// lib/providers/admin_panel_provider.dart

import 'package:flutter/material.dart';
import 'package:mobile/ShowClassRoutine.dart';
import 'package:mobile/StudentResultPage.dart';
import 'package:mobile/calculateMarksPage.dart';
import 'package:mobile/newapplicants.dart';
import 'package:mobile/showAllStudent.dart';
import 'package:mobile/showStudentAttendance.dart';
import 'package:mobile/showexamschedule.dart';
import 'package:mobile/AddExamSchedulePage.dart';
import 'package:mobile/studenttable.dart';

class PanelItem {
  final String title;
  final IconData icon;
  final Color cardColor;
  final Color iconColor;
  final Widget page;

  PanelItem({
    required this.title,
    required this.icon,
    required this.cardColor,
    required this.iconColor,
    required this.page,
  });
}

class AdminPanelProvider with ChangeNotifier {
  final List<PanelItem> _items = [
    PanelItem(
      title: "New Applicants",
      icon: Icons.person,
      cardColor: Colors.teal,
      iconColor: Colors.green,
      page: NewApplicants(),
    ),
    PanelItem(
      title: "Add Student",
      icon: Icons.school,
      cardColor: Colors.brown,
      iconColor: Colors.deepOrange,
      page: StudentTable(),
    ),
    PanelItem(
      title: "Student Details",
      icon: Icons.group,
      cardColor: Colors.indigo,
      iconColor: Colors.blue,
      page: ShowAllStudentsScreen(),
    ),
    PanelItem(
      title: "Exam Report",
      icon: Icons.receipt,
      cardColor: Colors.deepOrange,
      iconColor: Colors.amber,
      page: CalculateMarksPage(),
    ),
    PanelItem(
      title: "Attendance",
      icon: Icons.event_available,
      cardColor: Colors.purple,
      iconColor: Colors.brown,
      page: Showstudentattendance(),
    ),
    PanelItem(
      title: "Set Exam Schedule",
      icon: Icons.schedule,
      cardColor: Colors.deepOrange,
      iconColor: Colors.orange,
      page: AddExamSchedulePage(),
    ),
    PanelItem(
      title: "Exam Schedule",
      icon: Icons.calendar_today,
      cardColor: Colors.redAccent,
      iconColor: Colors.indigo,
      page: ShowExamSchedule(),
    ),
    PanelItem(
      title: "Class Routine",
      icon: Icons.class_,
      cardColor: Colors.blue,
      iconColor: Colors.indigo,
      page: ShowClassRoutine(),
    ),
    PanelItem(
      title: "Result Sheet",
      icon: Icons.bar_chart,
      cardColor: Colors.indigo,
      iconColor: Colors.amber,
      page: StudentResultPage(),
    ),
  ];

  List<PanelItem> get items => _items;
}
