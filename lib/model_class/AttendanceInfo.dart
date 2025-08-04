// lib/model_class/attendance_info.dart
class AttendanceInfo {
  final int? attendanceId;
  final int? studentId;
  final String? studentName;
  final String? class1;
  final String? section;
  final String? attendanceDate;
  final String? attendanceStatus;

  AttendanceInfo({
    required this.attendanceId,
    required this.studentId,
    required this.studentName,
    required this.class1,
    required this.section,
    required this.attendanceDate,
    required this.attendanceStatus,
  });

  String? get attendanceIdStr => attendanceId?.toString();

  factory AttendanceInfo.fromJson(Map<String, dynamic> json) => AttendanceInfo(
        attendanceId: json['attendanceId'],
        studentId: json['studentId'],
        studentName: json['studentName'],
        class1: json['class1'],
        section: json['section'],
        attendanceDate: json['attendanceDate'],
        attendanceStatus: json['attendanceStatus'],
      );

  Map<String, dynamic> toJson() => {
        'attendanceId': attendanceId,
        'studentId': studentId,
        'studentName': studentName,
        'class1': class1,
        'section': section,
        'attendanceDate': attendanceDate,
        'attendanceStatus': attendanceStatus,
      };
}
