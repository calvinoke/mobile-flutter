import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/teacherpanel.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/model_class/onlineadmission.dart';
import 'package:mobile/model_class/marks.dart';
import 'package:mobile/providers/marks_provider.dart';

class CalculateMarksPage extends StatefulWidget {
  const CalculateMarksPage({super.key});

  @override
  State<CalculateMarksPage> createState() => _CalculateMarksPageState();
}

class _CalculateMarksPageState extends State<CalculateMarksPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _totalMarksController = TextEditingController();
  final TextEditingController _scoredMarksController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _totalMarksController.dispose();
    _scoredMarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final Onlineadmission? student = userProvider.student;

        if (student == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Calculate Marks'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Student: ${student.fullName}'),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Subject',
                  controller: _subjectController,
                ),
                _buildTextField(
                  label: 'Total Marks',
                  controller: _totalMarksController,
                  type: TextInputType.number,
                ),
                _buildTextField(
                  label: 'Scored Marks',
                  controller: _scoredMarksController,
                  type: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final String subject = _subjectController.text.trim();
                    final int? totalMarks = int.tryParse(_totalMarksController.text);
                    final int? scoredMarks = int.tryParse(_scoredMarksController.text);

                    if (subject.isEmpty || totalMarks == null || scoredMarks == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields correctly')),
                      );
                      return;
                    }

                    final marksProvider = Provider.of<MarksProvider>(context, listen: false);

                    marksProvider.studentId.text = student.regNo.toString();
                    marksProvider.studentName.text = student.fullName;
                    marksProvider.studentClass.text = student.className ?? '';

                    marksProvider.subjectControllers[subject] ??= TextEditingController();
                    marksProvider.subjectControllers[subject]!.text = scoredMarks.toString();

                    marksProvider.calculateResult();

                    final marks = Marks(
                      examTitle: marksProvider.examTitle.text.isEmpty
                          ? 'Exam'
                          : marksProvider.examTitle.text,
                      studentId: student.regNo!,
                      studentName: student.fullName,
                      studentClass: student.className ?? '',
                      subjectMarks: marksProvider.subjectControllers.map(
                        (key, controller) => MapEntry(
                          key,
                          double.tryParse(controller.text) ?? 0.0,
                        ),
                      ),
                    );

                    marksProvider.addMarks(marks);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marks added successfully')),
                    );

                    _subjectController.clear();
                    _totalMarksController.clear();
                    _scoredMarksController.clear();
                  },
                  child: const Text('Add Marks'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
