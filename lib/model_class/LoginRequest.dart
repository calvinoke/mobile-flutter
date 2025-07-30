// This class represents the login request model containing user credentials
class LoginRequest {
  // The user's email address used for logging in
  final String email;

  // The user's password used for authentication
  final String password;

  // Constructor to initialize the LoginRequest with required email and password
  LoginRequest({
    required this.email,
    required this.password,
  });

  // Converts the LoginRequest instance into a JSON map
  // This is typically used when sending login data to an API
  Map<String, dynamic> toJson() => {
        // Converts the email to lowercase and trims whitespace for consistency
        "email": email.trim().toLowerCase(),
        
        // Keeps the password as-is (assumes it's already secure)
        "password": password,
      };
}
