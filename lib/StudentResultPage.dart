import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StudentResultPage extends StatefulWidget {
  @override
  _StudentResultPageState createState() => _StudentResultPageState();
}

class _StudentResultPageState extends State<StudentResultPage> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _resultIdController = TextEditingController(); // For update/delete

  Map<String, dynamic>? resultData;
  String? errorMessage;
  bool isLoading = false;

  String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  void _setLoading(bool value) => setState(() => isLoading = value);

  Future<void> createResult() async {
    _setLoading(true);
    final url = Uri.parse('$baseUrl/results');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'student_id': int.tryParse(_studentIdController.text),
        'class1': _classController.text,
        'score': int.tryParse(_scoreController.text),
        'Result': 'Pass', // Example value
      }),
    );
    handleResponse(response, 'created');
  }

  Future<void> getResult() async {
    _setLoading(true);
    final studentId = _studentIdController.text;
    final className = _classController.text;
    final url = Uri.parse('$baseUrl/results?studentId=$studentId&class=$className');
    final response = await http.get(url);
    handleResponse(response, 'fetched');
  }

  Future<void> updateResult() async {
    _setLoading(true);
    final id = _resultIdController.text;
    final url = Uri.parse('$baseUrl/results/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'score': int.tryParse(_scoreController.text),
        'Result': 'Pass', // Or recalculate
      }),
    );
    handleResponse(response, 'updated');
  }

  Future<void> deleteResult() async {
    _setLoading(true);
    final id = _resultIdController.text;
    final url = Uri.parse('$baseUrl/results/$id');
    final response = await http.delete(url);
    handleResponse(response, 'deleted');
  }

  void handleResponse(http.Response response, String action) {
    setState(() {
      isLoading = false;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isNotEmpty) {
          resultData = json.decode(response.body);
        } else {
          resultData = {'message': 'Result $action successfully'};
        }
        errorMessage = null;
      } else {
        errorMessage = 'Failed to $action result: ${response.body}';
        resultData = null;
      }
    });
  }

  Widget buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Result CRUD')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField(_studentIdController, 'Student ID', Icons.person),
            const SizedBox(height: 10),
            buildTextField(_classController, 'Class', Icons.school),
            const SizedBox(height: 10),
            buildTextField(_scoreController, 'Score', Icons.score),
            const SizedBox(height: 10),
            buildTextField(_resultIdController, 'Result ID (for update/delete)', Icons.fingerprint),
            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(onPressed: isLoading ? null : createResult, child: const Text('Create')),
                ElevatedButton(onPressed: isLoading ? null : getResult, child: const Text('Read')),
                ElevatedButton(onPressed: isLoading ? null : updateResult, child: const Text('Update')),
                ElevatedButton(onPressed: isLoading ? null : deleteResult, child: const Text('Delete')),
              ],
            ),
            const SizedBox(height: 20),

            if (isLoading) const CircularProgressIndicator(),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)),
            if (resultData != null)
              Card(
                margin: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: resultData!.entries.map((entry) {
                      return Text('${entry.key}: ${entry.value}', style: const TextStyle(fontSize: 16));
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
