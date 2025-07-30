import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/marks_provider.dart';
import 'package:mobile/teacherpanel.dart';

class CalculateMarksPage extends StatelessWidget {
  const CalculateMarksPage({super.key});

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: type ?? TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildResultTable(BuildContext context) {
    final provider = Provider.of<MarksProvider>(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            _buildTableRow('Total Marks', provider.totalMarks.toStringAsFixed(2)),
            _buildTableRow('Obtain Grade', provider.averageGrade.toStringAsFixed(2)),
            _buildTableRow('Result', provider.result),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MarksProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate Marks & Grade'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(label: 'Exam Title', controller: provider.examTitle),
            _buildTextField(label: 'Student ID', controller: provider.studentId, type: TextInputType.number),
            _buildTextField(label: 'Student Name', controller: provider.studentName),
            _buildTextField(label: 'Class', controller: provider.studentClass),

            ...provider.subjects.map((subject) => _buildTextField(
                  label: '$subject Marks',
                  controller: provider.subjectControllers[subject]!,
                  type: TextInputType.number,
                )),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: provider.calculateResult,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Calculate'),
            ),

            const SizedBox(height: 20),
            _buildResultTable(context),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Teacherpanel(
                      userName: 'demo_user', // Replace with real values
                      userEmail: 'demo@example.com',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Save Result'),
            ),
          ],
        ),
      ),
    );
  }
}
