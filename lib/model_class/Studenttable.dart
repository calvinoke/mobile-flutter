class Studenttable {
  int? student_id;
  String? full_name;
  String? dob;
  String? email;
  String? mob;
  String? gender;
  String? class1;
  String? subject;
  String? present_addres;
  String? permanent_address;
  String? session;
  String? status;
  String? section;

  Studenttable({
    required this.student_id,
    required this.full_name,
    required this.dob,
    required this.email,
    required this.mob,
    required this.gender,
    required this.class1,
    required this.subject,
    required this.present_addres,
    required this.permanent_address,
    required this.session,
    required this.status,
    required this.section,
  });
  factory Studenttable.fromJson(Map<String, dynamic> json) => Studenttable(
        student_id: json['student_id'],
        full_name: json['full_name'],
        dob: json['dob'],
        email: json['email'],
        mob: json['mob'],
        gender: json['gender'],
        class1: json['class1'],
        subject: json['subject'],
        present_addres: json['present_address'],
    permanent_address: json['permanent_address'],
        session: json['session'],
        status: json['status'],
        section: json['section'],
      );
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
      "present_address": present_addres,
      "permanent_address": permanent_address,
      "session": session,
      "status": status,
      "section": section
    };
  }
}
