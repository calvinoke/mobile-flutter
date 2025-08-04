class Marks {
  final int? id; // optional, for database or API use
  final String examTitle;
  final int studentId;
  final String studentName;
  final String studentClass;
  final Map<String, double> subjectMarks; // subject name to marks

  Marks({
    this.id,
    required this.examTitle,
    required this.studentId,
    required this.studentName,
    required this.studentClass,
    required this.subjectMarks,
  });

  factory Marks.fromJson(Map<String, dynamic> json) {
    // Parse subject marks as Map<String, double>
    final Map<String, dynamic> subjectsJson = json['subjectMarks'] ?? {};
    final subjectMarks = subjectsJson.map((key, value) => MapEntry(key, (value as num).toDouble()));

    return Marks(
      id: json['id'],
      examTitle: json['examTitle'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      studentClass: json['studentClass'],
      subjectMarks: subjectMarks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examTitle': examTitle,
      'studentId': studentId,
      'studentName': studentName,
      'studentClass': studentClass,
      'subjectMarks': subjectMarks,
    };
  }
}
