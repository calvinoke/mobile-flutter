import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mobile/providers/exam_schedule_provider.dart';

class ShowExamSchedule extends StatelessWidget {
  const ShowExamSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger fetching when widget is first built
    final examProvider = Provider.of<ExamScheduleProvider>(context, listen: false);
    // Fetch schedules once when entering screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      examProvider.fetchExamSchedules();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam Schedule"),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Consumer<ExamScheduleProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          if (provider.examSchedules.isEmpty) {
            return const Center(child: Text('No exam schedules found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.examSchedules.length,
            itemBuilder: (context, index) {
              final exam = provider.examSchedules[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Exam Title', exam.examTitle),
                      _buildInfoRow('Class', exam.class1),
                      _buildInfoRow('Subject', exam.subject),
                      _buildInfoRow('Exam Type', exam.examType),
                      _buildInfoRow('Exam Hall', exam.examHall),
                      _buildInfoRow('Start Time', DateFormat('hh:mm a').format(exam.examStart)),
                      _buildInfoRow('End Time', DateFormat('hh:mm a').format(exam.examEnd)),
                      _buildInfoRow('Invigilator', exam.examInvigilator),
                      _buildInfoRow('Date', DateFormat('yyyy-MM-dd').format(exam.examDate)),
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
        children: [
          Expanded(
            child: Text(
              '$title:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
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
