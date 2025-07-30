/// This class represents a response model that contains user information
/// along with an authentication token.
class UserResponse {
  /// The user object containing user details.
  final User user;

  /// The authentication token returned from the server (e.g., JWT).
  final String token;

  /// Constructor to create a UserResponse with the required fields.
  UserResponse({
    required this.user,
    required this.token,
  });

  /// Factory constructor to create a UserResponse object from a JSON map.
  ///
  /// - Parses the `user` field using the `User.fromJson` method.
  /// - Extracts the `token` directly from the JSON.
  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        user: User.fromJson(json['user']),
        token: json['token'],
      );
}
