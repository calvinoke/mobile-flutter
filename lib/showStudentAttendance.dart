import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/attendance_provider.dart';
import 'model_class/AttendanceInfo.dart';

class Showstudentattendance extends StatefulWidget {
  const Showstudentattendance({super.key});

  @override
  State<Showstudentattendance> createState() => _ShowstudentattendanceState();
}

class _ShowstudentattendanceState extends State<Showstudentattendance> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    provider.fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students Attendance List"),
        backgroundColor: Colors.teal,
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (provider.attendances.isEmpty) {
            return const Center(child: Text("No attendance data found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.attendances.length,
            itemBuilder: (BuildContext context, index) {
              final attendance = provider.attendances[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Attendance ID: ${attendance.attendanceId}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      _buildInfoRow('Student ID', attendance.studentId.toString()),
                      _buildInfoRow('Student Name', attendance.studentName ?? 'N/A'),
                      _buildInfoRow('Class', attendance.class1 ?? 'N/A'),
                      _buildInfoRow('Section', attendance.section ?? 'N/A'),
                      _buildInfoRow('Attendance Date', attendance.attendanceDate ?? 'N/A'),
                      _buildInfoRow('Attendance Status', attendance.attendanceStatus ?? 'N/A'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '$title:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.teal.shade800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
