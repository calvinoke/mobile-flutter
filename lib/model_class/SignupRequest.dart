class SignupRequest {
  final String username;
  final String name;
  final String email;
  final String password;

  SignupRequest({
    required this.username,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "email": email,
        "password": password,
      };
}
