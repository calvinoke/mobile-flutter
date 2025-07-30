/// Represents a student's result information for a specific exam.
class ResultInfo {
  int? resultId; // Optional database ID
  String? studentId; // ID of the student
  String? class1; // Class name or grade
  String? section; // Section of the class
  Map<String, double>? subjectwiseResult; // Map of subject to marks
  String? passFail; // Pass or Fail status
  double? totalMarks; // Total marks scored
  double? grade; // Overall grade or percentage
  String? examTitle; // Title or name of the exam

//constructor...
  ResultInfo({
    this.resultId,
    required this.studentId,
    required this.class1,
    required this.section,
    required this.subjectwiseResult,
    this.passFail,
    this.totalMarks,
    this.grade,
    required this.examTitle,
  });

  /// Factory constructor to create a ResultInfo instance from JSON.
  factory ResultInfo.fromJson(Map<String, dynamic> json) {
    return ResultInfo(
      resultId: json['result_id'],
      studentId: json['student_id'] ?? '',
      class1: json['class1'] ?? '',
      section: json['section'] ?? '',
      // Safely convert subject-wise results from JSON (if null, fallback to empty map)
      subjectwiseResult: (json['subjectwise_result'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, (value as num).toDouble())) ?? {},
      passFail: json['pass_fail'],
      totalMarks: (json['total_marks'] as num?)?.toDouble(),
      grade: (json['grade'] as num?)?.toDouble(),
      examTitle: json['exam_title'] ?? '',
    );
  }

  /// Converts the ResultInfo instance to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'result_id': resultId,
      'student_id': studentId,
      'class1': class1,
      'section': section,
      'subjectwise_result': subjectwiseResult,
      'pass_fail': passFail,
      'total_marks': totalMarks,
      'grade': grade,
      'exam_title': examTitle,
    };
  }

  /// Optional: Calculate average marks from subject-wise result.
  double get averageMarks {
    if (subjectwiseResult == null || subjectwiseResult!.isEmpty) return 0.0;
    final total = subjectwiseResult!.values.reduce((a, b) => a + b);
    return total / subjectwiseResult!.length;
  }

  /// Optional: Check if the student passed
  bool get isPassed => passFail?.toLowerCase() == 'pass';
}
