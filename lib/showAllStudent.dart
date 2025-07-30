import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/model_class/Studenttable.dart';
import 'add_student_screen.dart';
import 'student_provider.dart';

class ShowAllStudentsScreen extends StatelessWidget {
  const ShowAllStudentsScreen({super.key});

  Widget _buildStudentCard(BuildContext context, Studenttable student) {
    final provider = Provider.of<StudentProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.person, 'Full Name', student.full_name ?? ''),
            _infoRow(Icons.cake, 'DOB', student.dob ?? ''),
            _infoRow(Icons.email, 'Email', student.email ?? ''),
            _infoRow(Icons.phone, 'Mobile', student.mob ?? ''),
            _infoRow(Icons.wc, 'Gender', student.gender ?? ''),
            _infoRow(Icons.class_, 'Class', student.class1 ?? ''),
            _infoRow(Icons.school, 'Session', student.session ?? ''),
            _infoRow(Icons.group, 'Section', student.section ?? ''),
            _infoRow(Icons.check_circle, 'Status', student.status ?? ''),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddStudentScreen(student: student),
                      ),
                    ).then((_) => provider.fetchStudents());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final success = await provider.deleteStudent(student.id.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? "Student deleted successfully"
                            : "Failed to delete student"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentProvider()..fetchStudents(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Students Details')),
        body: Consumer<StudentProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search by name...',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: provider.updateSearchQuery,
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: provider.selectedClass,
                        items: provider.classes
                            .map((cls) => DropdownMenuItem(
                                  value: cls,
                                  child: Text(cls),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) provider.updateSelectedClass(val);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: provider.filteredStudents.isEmpty
                      ? const Center(child: Text("No students found"))
                      : ListView.builder(
                          itemCount: provider.filteredStudents.length,
                          itemBuilder: (context, index) {
                            return _buildStudentCard(
                                context, provider.filteredStudents[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Consumer<StudentProvider>(
          builder: (context, provider, _) => FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddStudentScreen(),
                ),
              ).then((_) => provider.fetchStudents());
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
