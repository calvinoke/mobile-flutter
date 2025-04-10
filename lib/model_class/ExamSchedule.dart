
class Examschedule {
  final String examTitle;

  final String class1;
  final String subject;
  final String examType;
  final String examHall;
  final String examStart;
  final String examEnd;
  final String examInvigilator;
  final String examDate;

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

  factory Examschedule.fromJson(Map<String, dynamic> json) => Examschedule(
    examTitle: json["examTitle"] ?? '',

    class1: json["class1"] ?? '',
    subject: json["subject"] ?? '',
    examType: json["examType"] ?? '',
    examHall: json["examHall"] ?? '', // Ensure this matches your JSON field
    examStart: json["examStart"] ?? '',
    examEnd: json["examEnd"] ?? '',
    examInvigilator: json["examInvigilator"] ?? '',
    examDate: json["examDate"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "examTitle": examTitle,

    "class": class1,
    "subject": subject,
    "examType": examType,
    "examHall": examHall, // Ensure this matches your JSON field
    "examStart": examStart,
    "examEnd": examEnd,
    "examInvigilator": examInvigilator,
    "examDate": examDate,
  };
}
