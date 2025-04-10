class Alluser {

  String? username;
  String? name;
  String? email;
  String? password;
  String? image;
  String? role;


  Alluser({
    required this.username,
    required this.name,
    required this.email,
    required this.password,
    required this.image,
    required this.role,

  });
  factory Alluser.fromJson(Map<String, dynamic> json) => Alluser(
    username: json['username'],
    name: json['name'],
    email: json['email'],
    password: json['password'],
    image: json['image'],
    role: json['role'],

  );
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "name": name,
      "email": email,
      "password": password,
      "image": image,
      "role": role,

    };
  }
}
