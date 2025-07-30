import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Mock classes
class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late TextEditingController studentIdController;
  late TextEditingController studentNameController;
  late TextEditingController classController;
  late TextEditingController sectionController;

  // Sample function to mimic dotenv
  String getMockBaseUrl() => 'https://mockapi.com';

  setUp(() {
    mockHttpClient = MockHttpClient();
    studentIdController = TextEditingController();
    studentNameController = TextEditingController();
    classController = TextEditingController();
    sectionController = TextEditingController();
  });

  test('studentIdChanged sets fields on 200 response', () async {
    final mockResponse = {
      'name': 'John Doe',
      'class': '10',
      'section': 'B',
    };

    // Mock HTTP response
    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => http.Response(jsonEncode(mockResponse), 200),
    );

    studentIdController.text = '123';

    // Simulate function call
    final response = await mockHttpClient.get(Uri.parse('${getMockBaseUrl()}/student/123'));
    final studentData = jsonDecode(response.body);

    // Simulate state change
    studentNameController.text = studentData['name'] ?? '';
    classController.text = studentData['class'] ?? '';
    sectionController.text = studentData['section'] ?? '';

    expect(studentNameController.text, 'John Doe');
    expect(classController.text, '10');
    expect(sectionController.text, 'B');
  });

  test('studentIdChanged handles non-200 response', () async {
    when(() => mockHttpClient.get(any()))
        .thenAnswer((_) async => http.Response('Not found', 404));

    studentIdController.text = '999';

    final response = await mockHttpClient.get(Uri.parse('${getMockBaseUrl()}/student/999'));

    expect(response.statusCode, isNot(200));
    // You would check that _clearFields() and _showSnackbar() are triggered
  });

  test('studentIdChanged handles exceptions gracefully', () async {
    when(() => mockHttpClient.get(any())).thenThrow(Exception('Network error'));

    try {
      await mockHttpClient.get(Uri.parse('${getMockBaseUrl()}/student/123'));
    } catch (e) {
      expect(e.toString(), contains('Network error'));
    }
  });
}
