/// This class models the attendance information for a student.
class Attendanceinfo {
  /// Unique ID for the attendance record (nullable)
  int? attendanceId;

  /// Unique ID of the student (nullable)
  int? studentId;

  /// Full name of the student (nullable)
  String? studentName;

  /// Class name or grade the student belongs to (nullable)
  String? class1;

  /// Section of the class (nullable)
  String? section;

  /// Date of the attendance in string format (e.g., "2024-06-30") (nullable)
  String? attendanceDate;

  /// Attendance status (e.g., "Present", "Absent") (nullable)
  String? attendanceStatus;

  /// Constructor for creating an Attendanceinfo object with required fields
  Attendanceinfo({
    required this.attendanceId,
    required this.studentId,
    required this.studentName,
    required this.class1,
    required this.section,
    required this.attendanceDate,
    required this.attendanceStatus,
  });

  /// Factory method to create an Attendanceinfo instance from a JSON map
  factory Attendanceinfo.fromJson(Map<String, dynamic> json) => Attendanceinfo(
        attendanceId: json['attendanceId'],
        studentId: json['studentId'],
        studentName: json['studentName'],
        class1: json['class1'],
        section: json['section'],
        attendanceDate: json['attendanceDate'],
        attendanceStatus: json['attendanceStatus'],
      );

  /// Converts an Attendanceinfo object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      "attendanceId": attendanceId,
      "studentId": studentId,
      "studentName": studentName,
      "class1": class1,
      "section": section,
      "attendanceDate": attendanceDate,
      "attendanceStatus": attendanceStatus,
    };
  }
}
