// import 'package:flutter/material.dart';
// import 'package:school_management/ShowClassRoutine.dart';
// import 'package:school_management/calculateMarksPage.dart';
// import 'package:school_management/main.dart';
// import 'package:school_management/newapplicants.dart';
// import 'package:school_management/showAllStudent.dart';
// import 'package:school_management/showStudentAttendance.dart';
// import 'package:school_management/showexamschedule.dart';
// import 'package:school_management/studenttable.dart';
//
// class Adminpanel extends StatefulWidget {
//   const Adminpanel({super.key});
//
//   @override
//   State<Adminpanel> createState() => _AdminpanelState();
// }
//
// class _AdminpanelState extends State<Adminpanel> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text('Azizur Rahman'),
//               accountEmail: Text('Aziz@gmail.com'),
//               currentAccountPicture: CircleAvatar(
//                 child: ClipOval(
//                   child: Image.asset("images/cvpic.png", fit: BoxFit.fill),
//                 ),
//               ),
//               decoration: const BoxDecoration(
//                 color: Colors.pinkAccent,
//                 image: DecorationImage(
//                     image: AssetImage('images/cvpic.png'), fit: BoxFit.cover),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Admin'),
//               onTap: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => MyApp()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => MyApp()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.call),
//               title: Text('Contact'),
//               onTap: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => MyApp()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.email),
//               title: Text('Email Address'),
//               onTap: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => MyApp()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => MyApp()));
//               },
//             ),
//           ],
//         ),
//       ),
//
//       appBar: AppBar(
//         title: Text("Welcome to Admin Panel"),
//         backgroundColor: Colors.pink,
//       ),
//
//       // ---------------------- body -----------------
//
//       body: Column(
//         children: [
//           Container(
//
//             width: double.infinity,
//
//             child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUmMCmQcHYBJ5u5oNSwibGuM4XCJiwY8BJXORfS1P7Ve9gw0ikNy1cujPl28_nCtT9GGw&usqp=CAU"),
//           ),
//
//           Expanded(
//             child: GridView.count(
//               crossAxisCount: 3,
//               padding: EdgeInsets.all(20),
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//               primary: false,
//               children: <Widget>[
//                 Card(
//                   color: Colors.teal,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: SizedBox.fromSize(
//                       size: Size(80, 80),
//                       child: ClipOval(
//                         child: Material(
//                           color: Colors.green,
//                           child: InkWell(
//                             splashColor: Colors.green,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.person,
//                                   color: Colors.white,
//                                   size: 30,
//                                 ),
//                                 Text(
//                                   "New Applicants",
//                                   style: TextStyle(
//                                       fontSize: 11, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => Newapplicants()));
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.brown,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: SizedBox.fromSize(
//                       size: Size(80, 80),
//                       child: ClipOval(
//                         child: Material(
//                           color: Colors.deepOrange,
//                           child: InkWell(
//                             splashColor: Colors.green,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.school,
//                                   color: Colors.white,
//                                   size: 30,
//                                 ),
//                                 Text(
//                                   "Add student",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => Studenttable()));
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.indigo,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: SizedBox.fromSize(
//                       size: Size(80, 80),
//                       child: ClipOval(
//                         child: Material(
//                           color: Colors.blue,
//                           child: InkWell(
//                             splashColor: Colors.green,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.group,
//                                   color: Colors.white,
//                                   size: 35,
//                                 ),
//                                 Text(
//                                   "Student Details",
//                                   style: TextStyle(
//                                       fontSize: 9, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => Showallstudent()));
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.deepOrange,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: SizedBox.fromSize(
//                       size: Size(80, 80),
//                       child: ClipOval(
//                         child: Material(
//                           color: Colors.amber,
//                           child: InkWell(
//                             splashColor: Colors.green,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.group,
//                                   color: Colors.white,
//                                   size: 35,
//                                 ),
//                                 Text(
//                                   "Exam Report",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => CalculateMarksPage()));},
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.purple,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: SizedBox.fromSize(
//                       size: Size(80, 80),
//                       child: ClipOval(
//                         child: Material(
//                           color: Colors.brown,
//                           child: InkWell(
//                             splashColor: Colors.green,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.login,
//                                   color: Colors.white,
//                                   size: 35,
//                                 ),
//                                 Text(
//                                   "Attendance",
//                                   style: TextStyle(
//                                       fontSize: 10, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           Showstudentattendance()));
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.deepOrange,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: SizedBox.fromSize(
//                       size: Size(80, 80),
//                       child: ClipOval(
//                         child: Material(
//                           color: Colors.orange,
//                           child: InkWell(
//                             splashColor: Colors.green,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.app_registration,
//                                   color: Colors.white,
//                                   size: 35,
//                                 ),
//                                 Text(
//                                   "Set Exam Schedule",
//                                   style: TextStyle(
//                                       fontSize: 9, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {},
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.redAccent,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: SizedBox.fromSize(
//                       size: Size(80, 80),
//                       child: ClipOval(
//                         child: Material(
//                           color: Colors.indigo,
//                           child: InkWell(
//                             splashColor: Colors.green,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.app_registration,
//                                   color: Colors.white,
//                                   size: 35,
//                                 ),
//                                 Text(
//                                   "Exam Schedule",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           Showexamschedule()));
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.blue,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: SizedBox.fromSize(
//                       size: Size(80, 80),
//                       child: ClipOval(
//                         child: Material(
//                           color: Colors.indigo,
//                           child: InkWell(
//                             splashColor: Colors.green,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.class_,
//                                   color: Colors.white,
//                                   size: 35,
//                                 ),
//                                 Text(
//                                   "Class Routine",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           ShowClassRoutine()));
//
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.indigo,
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     child: SizedBox.fromSize(
//                       size: Size(80, 80),
//                       child: ClipOval(
//                         child: Material(
//                           color: Colors.amber,
//                           child: InkWell(
//                             splashColor: Colors.green,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.group,
//                                   color: Colors.white,
//                                   size: 35,
//                                 ),
//                                 Text(
//                                   "Fee Management",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {},
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//
//       // ---------------------- floating action button -----------------
//
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.arrow_back),
//         tooltip: 'go next page',
//         onPressed: () {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => MyApp()));
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:school_management/ShowClassRoutine.dart';
import 'package:school_management/StudentResultPage.dart';
import 'package:school_management/calculateMarksPage.dart';
import 'package:school_management/main.dart';
import 'package:school_management/newapplicants.dart';
import 'package:school_management/showAllStudent.dart';
import 'package:school_management/showStudentAttendance.dart';
import 'package:school_management/showexamschedule.dart';
import 'package:school_management/AddExamSchedulePage.dart';

import 'package:school_management/studenttable.dart';

class Adminpanel extends StatefulWidget {
  const Adminpanel({super.key});

  @override
  State<Adminpanel> createState() => _AdminpanelState();
}

class _AdminpanelState extends State<Adminpanel> {
  int hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Azizur Rahman'),
              accountEmail: Text('Aziz@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset("images/download.png", fit: BoxFit.fill),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.pinkAccent,
                image: DecorationImage(
                    image: AssetImage('images/cvpic.png'), fit: BoxFit.cover),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Admin'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
            ListTile(
              leading: Icon(Icons.call),
              title: Text('Contact'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email Address'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Welcome to Admin Panel"),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUmMCmQcHYBJ5u5oNSwibGuM4XCJiwY8BJXORfS1P7Ve9gw0ikNy1cujPl28_nCtT9GGw&usqp=CAU"),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: EdgeInsets.all(20),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              primary: false,
              children: List.generate(9, (index) {
                return MouseRegion(
                  onEnter: (_) => setState(() {
                    hoveredIndex = index;
                  }),
                  onExit: (_) => setState(() {
                    hoveredIndex = -1;
                  }),
                  child: Card(
                    color: hoveredIndex == index
                        ? Colors.lightBlueAccent
                        : _getCardColor(index),
                    elevation: hoveredIndex == index ? 12 : 4,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: SizedBox.fromSize(
                        size: Size(80, 80),
                        child: ClipOval(
                          child: Material(
                            color: _getMaterialColor(index),
                            child: InkWell(
                              splashColor: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    _getIcon(index),
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  Text(
                                    _getText(index),
                                    style: TextStyle(
                                        fontSize: _getFontSize(index),
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              onTap: () => _onCardTap(context, index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        tooltip: 'Go to the previous page',
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        },
      ),
    );
  }

  Color _getCardColor(int index) {
    switch (index) {
      case 0:
        return Colors.teal;
      case 1:
        return Colors.brown;
      case 2:
        return Colors.indigo;
      case 3:
        return Colors.deepOrange;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.deepOrange;
      case 6:
        return Colors.redAccent;
      case 7:
        return Colors.blue;
      case 8:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Color _getMaterialColor(int index) {
    switch (index) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.deepOrange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.brown;
      case 5:
        return Colors.orange;
      case 6:
        return Colors.indigo;
      case 7:
        return Colors.indigo;
      case 8:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.school;
      case 2:
        return Icons.group;
      case 3:
        return Icons.group;
      case 4:
        return Icons.login;
      case 5:
        return Icons.app_registration;
      case 6:
        return Icons.app_registration;
      case 7:
        return Icons.class_;
      case 8:
        return Icons.group;
      default:
        return Icons.help;
    }
  }

  String _getText(int index) {
    switch (index) {
      case 0:
        return "New Applicants";
      case 1:
        return "Add Student";
      case 2:
        return "Student Details";
      case 3:
        return "Exam Report";
      case 4:
        return "Attendance";
      case 5:
        return "Set Exam Schedule";
      case 6:
        return "Exam Schedule";
      case 7:
        return "Class Routine";
      case 8:
        return "Result Sheet";
      default:
        return "Unknown";
    }
  }

  double _getFontSize(int index) {
    switch (index) {
      case 0:
        return 11;
      case 1:
        return 12;
      case 2:
        return 9;
      case 3:
        return 12;
      case 4:
        return 10;
      case 5:
        return 9;
      case 6:
        return 12;
      case 7:
        return 12;
      case 8:
        return 12;
      default:
        return 10;
    }
  }

  void _onCardTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Newapplicants()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Studenttable()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShowAllStudent()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CalculateMarksPage()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Showstudentattendance()));
        break;
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddExamSchedulePage()));
        break;
      case 6:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Showexamschedule()));
        break;
      case 7:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShowClassRoutine()));
        break;
      case 8:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StudentResultPage()));
        break;
    // Add other cases as needed
    }
  }
}
