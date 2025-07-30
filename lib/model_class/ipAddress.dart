class Ip {
  static const String dev = "http://192.168.43.44:8080";
  static const String prod = "https://api.yourdomain.com";

  /// Switch between environments...
  static String get baseUrl => kReleaseMode ? prod : dev;
}
