import 'package:flutter/material.dart';
import 'package:school_management/ShowClassRoutine.dart';
import 'package:school_management/StudentResultPage.dart';
import 'package:school_management/calculateMarksPage.dart';
import 'package:school_management/showAttendanceById.dart';
import 'package:school_management/showStudentAttendance.dart';

import 'package:school_management/showexamschedule.dart';
import 'package:school_management/main.dart';
import 'package:school_management/takeattendance.dart';

class Teacherpanel extends StatefulWidget {
  const Teacherpanel({super.key});

  @override
  State<Teacherpanel> createState() => _TeacherpanelState();
}

class _TeacherpanelState extends State<Teacherpanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Afsana Ema',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              accountEmail:
                  Text('Ema@gmail.com', style: TextStyle(fontSize: 16)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("images/p2.png"),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            _buildDrawerItem(Icons.person, 'Teacher', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Teacherpanel()));
            }),
            _buildDrawerItem(Icons.home, 'Home', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            }),
            _buildDrawerItem(Icons.call, 'Contact', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Teacherpanel()));
            }),
            _buildDrawerItem(Icons.email, 'Email Address', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Teacherpanel()));
            }),
            _buildDrawerItem(Icons.settings, 'Settings', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Teacherpanel()));
            }),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Welcome to Teacher Panel"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://static.vecteezy.com/system/resources/previews/004/641/880/non_2x/illustration-of-high-school-building-school-building-free-vector.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: <Widget>[
                  _buildGridItem(Icons.person, "Student Attendance List",
                      Colors.blue, Showstudentattendance()),
                  _buildGridItem(Icons.notifications, "Search Student",
                      Colors.green, SearchId()),
                  _buildGridItem(Icons.login, "Take Attendance",
                      Colors.deepOrange, TakeAttendance()),
                  _buildGridItem(Icons.school, "Exam Schedule", Colors.orange,
                      Showexamschedule()),
                  _buildGridItem(Icons.group, "Exam Report", Colors.brown,
                      CalculateMarksPage()),
                  _buildGridItem(Icons.calendar_today, "Class Timetable",
                      Colors.teal, ShowClassRoutine()),
                  _buildGridItem(Icons.school, "Result Sheet", Colors.blue,
                      StudentResultPage()),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.pinkAccent),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildGridItem(IconData icon, String title, Color color, Widget page) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.white, size: 40),
              SizedBox(height: 8),
              Text(title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
