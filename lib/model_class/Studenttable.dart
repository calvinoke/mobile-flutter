// This class represents a student record, typically stored in a student table in a database.
class Studenttable {
  // Unique identifier for the student
  int? student_id;

  // Full name of the student
  String? full_name;

  // Date of birth of the student
  String? dob;

  // Email address of the student
  String? email;

  // Mobile number of the student
  String? mob;

  // Gender of the student (e.g., Male, Female, Other)
  String? gender;

  // Class or grade of the student (e.g., 10th, 12th)
  String? class1;

  // Subject specialization or major, if applicable
  String? subject;

  // Present/Current address of the student
  String? present_address;

  // Permanent address of the student
  String? permanent_address;

  // Academic session (e.g., 2023-2024)
  String? session;

  // Status of the student (e.g., Active, Inactive, Graduated)
  String? status;

  // Section or group in which the student is placed (e.g., A, B)
  String? section;

  // Constructor to initialize the student record
  Studenttable({
    required this.student_id,
    required this.full_name,
    required this.dob,
    required this.email,
    required this.mob,
    required this.gender,
    required this.class1,
    required this.subject,
    required this.present_address,
    required this.permanent_address,
    required this.session,
    required this.status,
    required this.section,
  });

  // Factory constructor to create a Studenttable instance from a JSON map
  factory Studenttable.fromJson(Map<String, dynamic> json) => Studenttable(
        student_id: json['student_id'],
        full_name: json['full_name'],
        dob: json['dob'],
        email: json['email'],
        mob: json['mob'],
        gender: json['gender'],
        class1: json['class1'],
        subject: json['subject'],
        present_address: json['present_address'],  // JSON key uses 'present_address'
        permanent_address: json['permanent_address'],
        session: json['session'],
        status: json['status'],
        section: json['section'],
      );

  // Method to convert a Studenttable instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      "student_id": student_id,
      "full_name": full_name,
      "dob": dob,
      "email": email,
      "mob": mob,
      "gender": gender,
      "class1": class1,
      "subject": subject,
      "present_address": present_address,  // Output as 'present_address' for consistency
      "permanent_address": permanent_address,
      "session": session,
      "status": status,
      "section": section
    };
  }
}
