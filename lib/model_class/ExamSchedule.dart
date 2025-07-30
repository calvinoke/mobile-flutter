import 'package:intl/intl.dart';

/// Represents a scheduled exam entry for a class and subject.
class Examschedule {
  /// Title of the exam (e.g., "Mid-Term Exam")
  final String examTitle;

  /// Name of the class or grade (e.g., "Grade 10")
  final String class1;

  /// Subject of the exam (e.g., "Mathematics")
  final String subject;

  /// Type of the exam (e.g., "Written", "Oral")
  final String examType;

  /// Location where the exam will take place (e.g., "Hall A")
  final String examHall;

  /// Start time of the exam
  final DateTime examStart;

  /// End time of the exam
  final DateTime examEnd;

  /// Name of the invigilator responsible for the exam
  final String examInvigilator;

  /// Date of the exam
  final DateTime examDate;

  /// Constructor to initialize all fields
  Examschedule({
    required this.examTitle,
    required this.class1,
    required this.subject,
    required this.examType,
    required this.examHall,
    required this.examStart,
    required this.examEnd,
    required this.examInvigilator,
    required this.examDate,
  });

  /// Factory method to create an instance from a JSON map
  factory Examschedule.fromJson(Map<String, dynamic> json) {
    return Examschedule(
      examTitle: json['examTitle'] ?? '',
      class1: json['class1'] ?? '',
      subject: json['subject'] ?? '',
      examType: json['examType'] ?? '',
      examHall: json['examHall'] ?? '',
      examStart: DateTime.tryParse(json['examStart'] ?? '') ?? DateTime(2000),
      examEnd: DateTime.tryParse(json['examEnd'] ?? '') ?? DateTime(2000),
      examInvigilator: json['examInvigilator'] ?? '',
      examDate: DateTime.tryParse(json['examDate'] ?? '') ?? DateTime(2000),
    );
  }

  /// Converts this instance to a JSON map
  Map<String, dynamic> toJson() => {
        "examTitle": examTitle,
        "class1": class1,
        "subject": subject,
        "examType": examType,
        "examHall": examHall,
        "examStart": examStart.toIso8601String(),
        "examEnd": examEnd.toIso8601String(),
        "examInvigilator": examInvigilator,
        "examDate": examDate.toIso8601String(),
      };

  /// Checks whether the exam end time is after the start time
  bool isValidTimeRange() => examEnd.isAfter(examStart);

  /// Returns a user-friendly formatted date (e.g., "2025-05-13")
  String get formattedDate => DateFormat('yyyy-MM-dd').format(examDate);

  /// Returns a user-friendly formatted time range (e.g., "10:00 AM - 12:00 PM")
  String get formattedTimeRange =>
      '${DateFormat.jm().format(examStart)} - ${DateFormat.jm().format(examEnd)}';

  @override
  String toString() =>
      'Exam "$examTitle" for $subject on $formattedDate at $examHall (${formattedTimeRange})';
}
