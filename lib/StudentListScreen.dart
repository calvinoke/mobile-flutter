import 'package:flutter/material.dart'; // Flutter UI components
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // HTTP package for API calls
import 'package:flutter_dotenv/flutter_dotenv.dart'; // For loading environment variables from .env

// ---------------------
// Student Model
// ---------------------
class Student {
  final String id;
  final String name;
  final int age;

  // Constructor
  Student({required this.id, required this.name, required this.age});

  // Factory method to create a Student object from a JSON map
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'], // MongoDB document ID
      name: json['name'],
      age: json['age'],
    );
  }
}

// ---------------------
// StudentListScreen Widget
// ---------------------
class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  // List to store fetched students
  List<Student> students = [];

  // API URL fetched securely from .env file
  final String apiUrl = dotenv.env['API_URL']!;

  @override
  void initState() {
    super.initState();
    // Fetch students when the widget is initialized
    fetchStudents();
  }

  // ---------------------
  // Fetch Students from API
  // ---------------------
  Future<void> fetchStudents() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        // Parse JSON into a list of Student objects
        students = data.map((json) => Student.fromJson(json)).toList();
      });
    }
  }

  // ---------------------
  // Delete a student by ID
  // ---------------------
  Future<void> deleteStudent(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      // Refresh student list after deletion
      fetchStudents();
    } else {
      // Show error if deletion failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete student')),
      );
    }
  }

  // ---------------------
  // Navigate to Add Student screen
  // ---------------------
  void navigateToAddStudent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStudentScreen(
          onStudentAdded: fetchStudents, // Callback to refresh list
        ),
      ),
    );
  }

  // ---------------------
  // Navigate to Edit Student screen with student data
  // ---------------------
  void navigateToEditStudent(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStudentScreen(
          student: student, // Pass existing student for editing
          onStudentAdded: fetchStudents, // Callback to refresh list
        ),
      ),
    );
  }

  // ---------------------
  // UI Build Method
  // ---------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title
      appBar: AppBar(title: Text('Students')),

      // List of students
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text('Age: ${student.age}'),
            // Edit and Delete buttons
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => navigateToEditStudent(student),
                ),
                // Delete button
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteStudent(student.id),
                ),
              ],
            ),
          );
        },
      ),

      // Floating action button to add a new student
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddStudent,
        child: Icon(Icons.add),
      ),
    );
  }
}
