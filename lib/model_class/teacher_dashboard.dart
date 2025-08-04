class TeacherDashboard {
  final List<Course> courses;
  final List<Student> students;

  TeacherDashboard({
    required this.courses,
    required this.students,
  });

  factory TeacherDashboard.fromJson(Map<String, dynamic> json) {
    return TeacherDashboard(
      courses: (json['courses'] as List<dynamic>?)
              ?.map((item) => Course.fromJson(item))
              .toList() ??
          [],
      students: (json['students'] as List<dynamic>?)
              ?.map((item) => Student.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courses': courses.map((c) => c.toJson()).toList(),
      'students': students.map((s) => s.toJson()).toList(),
    };
  }
}

class Course {
  final String name;
  // Add more fields if needed

  Course({required this.name});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class Student {
  final String name;
  final String email;

  Student({
    required this.name,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
