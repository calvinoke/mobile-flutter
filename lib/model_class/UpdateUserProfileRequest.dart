/// This class represents a request model for updating a user's profile.
/// It is typically used when the user wants to update their name or profile image.
class UpdateUserProfileRequest {
  /// Optional updated name of the user.
  final String? name;

  /// Optional updated profile image (URL or base64 string, depending on backend expectations).
  final String? image;

  /// Constructor to create a new UpdateUserProfileRequest.
  /// Both fields are optional — this allows partial updates.
  UpdateUserProfileRequest({
    this.name,
    this.image,
  });

  /// Converts the UpdateUserProfileRequest object into a JSON-compatible map.
  ///
  /// - Only includes keys in the map if their values are non-null.
  /// - This is useful for partial updates where the user may only want to change one field.
  Map<String, dynamic> toJson() => {
        if (name != null) "name": name,
        if (image != null) "image": image,
      };
}
