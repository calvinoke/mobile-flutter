//
//
//
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:school_management/model_class/AttendanceInfo.dart';
// import 'package:school_management/model_class/ipAddress.dart';
//
// List<Attendanceinfo> objectsFromJson(String str) => List<Attendanceinfo>.from(
//     json.decode(str).map((x) => Attendanceinfo.fromJson(x)));
//
// String objectsToJson(List<Attendanceinfo> data) =>
//     json.encode(List<Attendanceinfo>.from(data.map((x) => x.toJson())));
//
// class SearchId extends StatefulWidget {
//   const SearchId({super.key});
//
//   @override
//   State<SearchId> createState() => _SearchIdState();
// }
//
// class _SearchIdState extends State<SearchId> {
//   final TextEditingController _studentIdController = TextEditingController();
//   late Future<List<Attendanceinfo>> _futureAttendance;
//
//   @override
//   void initState() {
//     super.initState();
//     _futureAttendance = Future.value([]);
//   }
//
//   Future<List<Attendanceinfo>> showById(String studentId) async {
//     Ip ip = Ip();
//     final response = await http.get(
//       Uri.parse('${ip.ipAddress}/searchstudentid/$studentId'),
//     );
//
//     if (response.statusCode == 200) {
//       return objectsFromJson(response.body);
//     } else {
//       throw Exception("Failed to load data");
//     }
//   }
//
//   void search() {
//     setState(() {
//       _futureAttendance = showById(_studentIdController.text);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Search By Student ID"),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search Form
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: TextFormField(
//                         controller: _studentIdController,
//                         decoration: InputDecoration(
//                           labelText: 'Student ID',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 16.0),
//                     Expanded(
//                       flex: 1,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           if (_studentIdController.text.isNotEmpty) {
//                             search();
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.teal,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           elevation: 5,
//                           padding: EdgeInsets.symmetric(vertical: 14.0),
//                           side: BorderSide(color: Colors.teal.shade700),
//                           shadowColor: Colors.teal.withOpacity(0.5),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.search, size: 20),
//                             SizedBox(width: 8.0),
//                             Text("Search"),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             // Data Table or No Data Card
//             Expanded(
//               child: FutureBuilder<List<Attendanceinfo>>(
//                 future: _futureAttendance,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
//                       ),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(
//                       child: Text(
//                         "Error: ${snapshot.error}",
//                         style: TextStyle(color: Colors.red, fontSize: 16),
//                       ),
//                     );
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(
//                       child: Card(
//                         color: Colors.teal.shade50,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         elevation: 2,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Text(
//                             "No data found",
//                             style: TextStyle(
//                               color: Colors.teal,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   } else {
//                     var attendanceList = snapshot.data!;
//                     return SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: DataTable(
//                         columnSpacing: 12.0,
//                         headingRowColor: MaterialStateProperty.all(Colors.teal.shade100),
//                         dataTextStyle: TextStyle(color: Colors.black87),
//                         headingTextStyle: TextStyle(
//                           color: Colors.teal.shade800,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         columns: const [
//                           DataColumn(label: Text('Student Name')),
//                           DataColumn(label: Text('Class')),
//                           DataColumn(label: Text('Section')),
//                           DataColumn(label: Text('Attendance Date')),
//                           DataColumn(label: Text('Attendance Status')),
//                         ],
//                         rows: attendanceList.map((attendance) {
//                           return DataRow(cells: [
//                             DataCell(
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(maxWidth: 100),
//                                 child: Text(attendance.studentName.toString(), overflow: TextOverflow.ellipsis),
//                               ),
//                             ),
//                             DataCell(
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(maxWidth: 100),
//                                 child: Text(attendance.class1.toString(), overflow: TextOverflow.ellipsis),
//                               ),
//                             ),
//                             DataCell(
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(maxWidth: 100),
//                                 child: Text(attendance.section.toString(), overflow: TextOverflow.ellipsis),
//                               ),
//                             ),
//                             DataCell(
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(maxWidth: 150),
//                                 child: Text(attendance.attendanceDate.toString(), overflow: TextOverflow.ellipsis),
//                               ),
//                             ),
//                             DataCell(
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(maxWidth: 150),
//                                 child: Text(attendance.attendanceStatus.toString(), overflow: TextOverflow.ellipsis),
//                               ),
//                             ),
//                           ]);
//                         }).toList(),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management/model_class/AttendanceInfo.dart';
import 'package:school_management/model_class/ipAddress.dart';

List<Attendanceinfo> objectsFromJson(String str) => List<Attendanceinfo>.from(
    json.decode(str).map((x) => Attendanceinfo.fromJson(x)));

String objectsToJson(List<Attendanceinfo> data) =>
    json.encode(List<Attendanceinfo>.from(data.map((x) => x.toJson())));

class SearchId extends StatefulWidget {
  const SearchId({super.key});

  @override
  State<SearchId> createState() => _SearchIdState();
}

class _SearchIdState extends State<SearchId> {
  final TextEditingController _studentIdController = TextEditingController();
  late Future<List<Attendanceinfo>> _futureAttendance;

  @override
  void initState() {
    super.initState();
    _futureAttendance = Future.value([]);
  }

  Future<List<Attendanceinfo>> showById(String studentId) async {
    Ip ip = Ip();
    final response = await http.get(
      Uri.parse('${ip.ipAddress}/searchstudentid/$studentId'),
    );

    if (response.statusCode == 200) {
      return objectsFromJson(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

  void search() {
    setState(() {
      _futureAttendance = showById(_studentIdController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search By Student ID"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Form
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _studentIdController,
                        decoration: InputDecoration(
                          labelText: 'Student ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_studentIdController.text.isNotEmpty) {
                            search();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 5,
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          side: BorderSide(color: Colors.teal.shade700),
                          shadowColor: Colors.teal.withOpacity(0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, size: 20),
                            SizedBox(width: 8.0),
                            Text("Search"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // List of Attendance Records
            Expanded(
              child: FutureBuilder<List<Attendanceinfo>>(
                future: _futureAttendance,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Card(
                        color: Colors.teal.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "No data found",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    var attendanceList = snapshot.data!;
                    return ListView.builder(
                      itemCount: attendanceList.length,
                      itemBuilder: (context, index) {
                        var attendance = attendanceList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(attendance.studentName.toString()),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Class: ${attendance.class1.toString()}'),
                                Text('Section: ${attendance.section.toString()}'),
                                Text('Date: ${attendance.attendanceDate.toString()}'),
                                Text('Status: ${attendance.attendanceStatus.toString()}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
