import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Provider import
import 'package:provider/provider.dart';
import 'package:mobile/providers/user_provider.dart';

import 'package:mobile/ShowClassRoutine.dart';
import 'package:mobile/StudentResultPage.dart';
import 'package:mobile/calculateMarksPage.dart';
import 'package:mobile/showAttendanceById.dart';
import 'package:mobile/showStudentAttendance.dart';
import 'package:mobile/showexamschedule.dart';
import 'package:mobile/takeattendance.dart';
import 'package:mobile/session_manager.dart';
import 'package:mobile/main.dart';

/// Main Teacher Panel screen with navigation to teacher functionalities.
class Teacherpanel extends StatefulWidget {
  const Teacherpanel({super.key});

  @override
  State<Teacherpanel> createState() => _TeacherpanelState();
}

class _TeacherpanelState extends State<Teacherpanel> {
  bool _isLoggingOut = false;
  File? _selectedImage;

  /// Opens image picker to allow the teacher to choose a profile picture.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  /// Logs the teacher out by calling the API and clearing session data.
  Future<void> _performLogout() async {
    setState(() => _isLoggingOut = true);

    final token = await SessionManager().get('auth_token');
    final baseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$baseUrl/logout');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Clear session and provider user
        await SessionManager().clear();

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.clearUser();

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/Login');
        }
      } else {
        final data = json.decode(response.body);
        _showError(data['message'] ?? 'Logout failed');
      }
    } catch (e) {
      _showError('Network error. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  /// Displays an error message using a Snackbar.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ));
  }

  /// Builds the main UI for the teacher panel.
  @override
  Widget build(BuildContext context) {
    // Get current user from provider
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      drawer: _buildDrawer(user),
      appBar: AppBar(
        title: const Text("Welcome to Teacher Panel"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Stack(
        children: [
          _buildMainContent(),
          if (_isLoggingOut)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the navigation drawer with user profile and options.
  Widget _buildDrawer(Alluser? user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user?.name ?? 'Teacher',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            currentAccountPicture: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : (user?.image != null && user!.image.isNotEmpty)
                        ? NetworkImage(user.image)
                        : const AssetImage("images/default_avatar.png") as ImageProvider,
              ),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          }),
          _buildDrawerItem(Icons.group, 'Teacher', null),
          _buildDrawerItem(Icons.phone, 'Contact', () {}),
          _buildDrawerItem(Icons.email, 'Email Address', () {}),
          _buildDrawerItem(Icons.settings, 'Settings', () {}),
          _buildDrawerItem(Icons.logout, 'Logout', _isLoggingOut ? null : _performLogout),
        ],
      ),
    );
  }

  /// Builds the drawer menu item with an icon and label.
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.pinkAccent),
      title: Text(title),
      onTap: onTap,
      enabled: onTap != null,
    );
  }

  /// Main dashboard layout including a banner and action grid.
  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Banner image
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage(
                  "https://static.vecteezy.com/system/resources/previews/004/641/880/non_2x/illustration-of-high-school-building-school-building-free-vector.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Teacher action grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildGridItem(Icons.person, "Student Attendance List", Colors.blue, const Showstudentattendance()),
                _buildGridItem(Icons.search, "Search Student", Colors.green, const SearchId()),
                _buildGridItem(Icons.login, "Take Attendance", Colors.deepOrange, TakeAttendance()),
                _buildGridItem(Icons.schedule, "Exam Schedule", Colors.orange, const ShowExamSchedule()),
                _buildGridItem(Icons.bar_chart, "Exam Report", Colors.brown, const CalculateMarksPage()),
                _buildGridItem(Icons.calendar_today, "Class Timetable", Colors.teal, const ShowClassRoutine()),
                _buildGridItem(Icons.assignment, "Result Sheet", Colors.indigo, StudentResultPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single dashboard grid item for navigation.
  Widget _buildGridItem(IconData icon, String title, Color color, Widget page) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
