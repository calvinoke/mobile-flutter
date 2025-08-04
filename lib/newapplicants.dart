import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/new_applicants_provider.dart';
import 'package:mobile/model_class/Onlineadmission.dart';
import 'package:intl/intl.dart';

class NewApplicants extends StatefulWidget {
  const NewApplicants({super.key});

  @override
  State<NewApplicants> createState() => _NewApplicantsState();
}

class _NewApplicantsState extends State<NewApplicants> {
  @override
  void initState() {
    super.initState();
    // Fetch students on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewApplicantsProvider>(context, listen: false).fetchStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewApplicantsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student List"),
        backgroundColor: Colors.pink,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text("Error: ${provider.error}"))
              : provider.students.isEmpty
                  ? const Center(child: Text("No students found."))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: provider.students.length,
                      itemBuilder: (context, index) {
                        return _buildStudentCard(provider.students[index]);
                      },
                    ),
    );
  }

  Widget _buildStudentCard(Onlineadmission student) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(student.image ?? ''),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Registration ID', student.regNo?.toString()),
            _buildInfoRow('Full Name', student.fullName),
            _buildInfoRow('Date of Birth', DateFormat('yyyy-MM-dd').format(student.dob)),
            _buildInfoRow('Email', student.email),
            _buildInfoRow('Mobile', student.mobile),
            _buildInfoRow('Gender', student.gender),
            _buildInfoRow('Class', student.className),
            _buildInfoRow('Section', student.section),
            _buildInfoRow('Session', student.session),
            _buildInfoRow('Present Address', student.presentAddress),
            _buildInfoRow('Permanent Address', student.permanentAddress),
            _buildInfoRow('Username', student.username),
            _buildInfoRow('Password', student.password),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? '', overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
