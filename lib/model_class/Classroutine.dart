import 'package:intl/intl.dart';

/// Enum representing valid days of the week.
enum WeekDay {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday,
}

WeekDay? weekDayFromString(String day) {
  try {
    return WeekDay.values.firstWhere(
      (e) => e.name.toLowerCase() == day.toLowerCase(),
    );
  } catch (_) {
    return null;
  }
}

/// Represents a class routine or schedule entry for a specific day.
class Classroutine {
  /// Day of the week
  final WeekDay day;

  /// Name of the class or grade (e.g., "Grade 10")
  final String className;

  /// Section of the class (e.g., "A")
  final String section;

  /// Subject being taught (e.g., "Mathematics")
  final String subject;

  /// Start time of the class
  final DateTime startTime;

  /// End time of the class
  final DateTime endTime;

  /// Name of the teacher taking the class
  final String teacher;

  /// Room number where the class takes place
  final String roomNo;

  /// Constructor with validation to ensure proper time and day values
  Classroutine({
    required this.day,
    required this.className,
    required this.section,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.teacher,
    required this.roomNo,
  }) {
    if (endTime.isBefore(startTime)) {
      throw ArgumentError('End time must be after start time');
    }
  }

  /// Factory constructor to create a Classroutine instance from JSON
  factory Classroutine.fromJson(Map<String, dynamic> json) {
    final parsedDay = weekDayFromString(json['day'] ?? '');
    if (parsedDay == null) {
      throw FormatException("Invalid day: '${json['day']}'");
    }

    final DateFormat formatter = DateFormat('HH:mm');

    return Classroutine(
      day: parsedDay,
      className: json['className'] ?? '',
      section: json['section'] ?? '',
      subject: json['subject'] ?? '',
      startTime: formatter.parse(json['startTime'] ?? '00:00'),
      endTime: formatter.parse(json['endTime'] ?? '00:00'),
      teacher: json['teacher'] ?? '',
      roomNo: json['roomNo'] ?? '',
    );
  }

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('HH:mm');
    return {
      "day": day.name,
      "className": className,
      "section": section,
      "subject": subject,
      "startTime": formatter.format(startTime),
      "endTime": formatter.format(endTime),
      "teacher": teacher,
      "roomNo": roomNo,
    };
  }

  /// Helpful for debugging and logging
  @override
  String toString() {
    return 'Classroutine(day: ${day.name}, className: $className, section: $section, '
        'subject: $subject, startTime: ${DateFormat('HH:mm').format(startTime)}, '
        'endTime: ${DateFormat('HH:mm').format(endTime)}, teacher: $teacher, roomNo: $roomNo)';
  }
}
