// import 'package:flutter/material.dart';
//
// class StudentResultPage extends StatefulWidget {
//   @override
//   _StudentResultPageState createState() => _StudentResultPageState();
// }
//
// class _StudentResultPageState extends State<StudentResultPage> {
//   final TextEditingController _studentIdController = TextEditingController();
//   final TextEditingController _classController = TextEditingController();
//
//   // Dummy data for demonstration
//   Map<String, dynamic> studentResult = {
//     'Bangla': 40,
//     'English': 30,
//     'Math': 80,
//     'Science': 20,
//     'Total': 170,
//     'Grade': 4.34,
//     'Result': 'Pass'
//   };
//
//   void _searchResult() {
//     // Logic to fetch the result based on student ID and class
//
//     setState(() {
//       // Assuming result fetched and updated in studentResult
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student Result'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Search Result',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueAccent,
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _studentIdController,
//               decoration: InputDecoration(
//                 labelText: 'Student ID',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.person),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _classController,
//               decoration: InputDecoration(
//                 labelText: 'Class',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.school),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _searchResult,
//               child: Text('Search'),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                 textStyle: TextStyle(fontSize: 18),
//               ),
//             ),
//             SizedBox(height: 30),
//             if (studentResult.isNotEmpty)
//               Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Result Details',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.teal,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       ...studentResult.entries.map((entry) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4.0),
//                           child: Text(
//                             '${entry.key}: ${entry.value}',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                       SizedBox(height: 10),
//                       Text(
//                         'Overall Result: ${studentResult['Result']}',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: studentResult['Result'] == 'Pass'
//                               ? Colors.green
//                               : Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: StudentResultPage(),
//   ));
// }



import 'package:flutter/material.dart';

class StudentResultPage extends StatefulWidget {
  @override
  _StudentResultPageState createState() => _StudentResultPageState();
}

class _StudentResultPageState extends State<StudentResultPage> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _classController = TextEditingController();

  // Dummy data representing multiple students' results
  final List<Map<String, dynamic>> studentResults = [
    {
      'studentId': '101',
      'class': '1st',
      'Bangla': 50,
      'English': 50,
      'Math': 50,
      'Science': 50,
      'Total': 200,
      'Grade': 3.00,
      'Result': 'Pass'
    },
    {
      'studentId': '102',
      'class': '2nd',
      'Bangla': 80,
      'English': 80,
      'Math': 80,
      'Science': 80,
      'Total': 320,
      'Grade': 5.00,
      'Result': 'fail'
    },
    {
      'studentId': '106',
      'class': '6th',
      'Bangla': 50,
      'English': 45,
      'Math': 75,
      'Science': 40,
      'Total': 210,
      'Grade': 4.75,
      'Result': 'Pass'
    },
    {
      'studentId': '109',
      'class': '9th',
      'Bangla': 70,
      'English': 70,
      'General Math': 70,
      'Religion': 70,

      'Physics': 70,
      'Chemistry': 70,
      'Biology': 32,

      'Total': 452,
      'Grade': 3.43,
      'Result': 'Fail'
    }
    // Add more student data here
  ];

  Map<String, dynamic>? searchedResult;

  get nul => null;

  void _searchResult() {
    String studentId = _studentIdController.text.trim();
    String className = _classController.text.trim();

    setState(() {
      searchedResult = studentResults.firstWhere(
            (student) => student['studentId'] == studentId && student['class'] == className,
        orElse: () => nul,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Search Result',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(
                labelText: 'Student ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _classController,
              decoration: InputDecoration(
                labelText: 'Class',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchResult,
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 30),
            if (searchedResult != null)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Result Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 10),
                      ...searchedResult!.entries.map((entry) {
                        if (entry.key != 'studentId' && entry.key != 'class') {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              '${entry.key}: ${entry.value}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      }).toList(),
                      SizedBox(height: 10),
                      Text(
                        'Overall Result: ${searchedResult!['Result']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: searchedResult!['Result'] == 'Pass'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (searchedResult == null && _studentIdController.text.isNotEmpty && _classController.text.isNotEmpty)
              Text(
                'No result found for the given Student ID and Class.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudentResultPage(),
  ));
}

