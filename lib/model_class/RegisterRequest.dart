/// This class represents the registration request model
/// used to send user details to the backend when signing up.
class RegisterRequest {
  /// Unique username selected by the user.
  final String username;

  /// Full name of the user.
  final String name;

  /// Email address of the user.
  final String email;

  /// Password chosen by the user (should be secured before sending).
  final String password;

  /// Constructor to create a new RegisterRequest object.
  /// All fields are required to ensure valid registration data.
  RegisterRequest({
    required this.username,
    required this.name,
    required this.email,
    required this.password,
  });

  /// Converts the RegisterRequest object into a JSON-compatible map.
  /// This map is typically sent in the body of a POST request to an API.
  ///
  /// - Trims whitespace from username and name to avoid accidental errors.
  /// - Converts email to lowercase and trims spaces for consistency.
  /// - Sends password as-is; consider hashing or encrypting if required by backend.
  Map<String, dynamic> toJson() => {
        "username": username.trim(),
        "name": name.trim(),
        "email": email.trim().toLowerCase(),
        "password": password, // Send raw only if backend expects it.
      };
}
