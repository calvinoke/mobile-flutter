import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:school_management/model_class/Studenttable.dart';
import 'package:school_management/model_class/ipAddress.dart';

List<Studenttable> objectsFromJson(String str) => List<Studenttable>.from(
    json.decode(str).map((x) => Studenttable.fromJson(x)));
String objectsToJson(List<Studenttable> data) =>
    json.encode(List<Studenttable>.from(data).map((x) => x.toJson()));

class ShowAllStudent extends StatefulWidget {
  const ShowAllStudent({super.key});

  @override
  State<ShowAllStudent> createState() => _ShowAllStudentState();
}

class _ShowAllStudentState extends State<ShowAllStudent> {
  Future<List<Studenttable>> showAllStudent() async {
    Ip ip = Ip();
    final response = await http.get(Uri.parse('${ip.ipAddress}/getall'));
    if (response.statusCode == 200) {
      return objectsFromJson(response.body);
    } else {
      throw Exception("Failed to load student data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students Details"),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<List<Studenttable>>(
        future: showAllStudent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                var student = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Icon(Icons.perm_identity, color: Colors.pink),
                              SizedBox(width: 10),
                              Text(
                                'Student ID: ${student.student_id}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.pink),
                              SizedBox(width: 10),
                              Text(
                                'Full Name: ${student.full_name}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.cake, color: Colors.pink),
                              SizedBox(width: 10),
                              Text(
                                'Date of Birth: ${student.dob}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.email, color: Colors.pink),
                              SizedBox(width: 10),
                              Text(
                                'Email: ${student.email}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.pink),
                              SizedBox(width: 10),
                              Text(
                                'Mobile: ${student.mob}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.wc, color: Colors.pink),
                              SizedBox(width: 10),
                              Text(
                                'Gender: ${student.gender}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.class_, color: Colors.pink),
                              SizedBox(width: 10),
                              Text(
                                'Class: ${student.class1}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.school, color: Colors.pink),
                              SizedBox(width: 10),
                              Text(
                                'Session: ${student.session}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.pink),
                              SizedBox(width: 10),
                              Text(
                                'Status: ${student.status}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.group, color: Colors.pink),
                              SizedBox(width: 10),
                              Text(
                                'Section: ${student.section}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading student data"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
