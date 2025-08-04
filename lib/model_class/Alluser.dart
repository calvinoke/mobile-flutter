class Alluser {
  final String username;
  final String name;
  final String email;
  final String image;
  final String role;
  final String password;
  final String token; 

  Alluser({
    required this.username,
    required this.name,
    required this.email,
    required this.image,
    required this.role,
    required this.password,
    required this.token, 
  });

  factory Alluser.fromJson(Map<String, dynamic> json) => Alluser(
        username: json['username'],
        name: json['name'],
        email: json['email'],
        image: json['image'],
        role: json['role'],
        password: json['password'] ?? '',
        token: json['token'] ?? '', 
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "email": email,
        "image": image,
        "role": role,
        "password": password,
        "token": token, 
      };
}
