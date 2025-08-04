import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/ShowClassRoutine.dart';
import 'package:mobile/main.dart';
import 'package:mobile/StudentResultPage.dart';
import 'package:mobile/showAttendanceById.dart';
import 'package:mobile/showexamschedule.dart';
import 'package:mobile/CalculateMarksPage.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/student_profile_provider.dart';

class Studentpanel extends StatelessWidget {
  const Studentpanel({super.key});

  @override
  Widget build(BuildContext context) {
    final apiUrl = dotenv.env['API_BASE_URL'] ?? 'Not Found';

    // Get student profile from provider
    final profile = Provider.of<StudentProfileProvider>(context);
    final name = profile.name;
    final email = profile.email;
    final imageUrl = profile.imageUrl ?? '';

    return Scaffold(
      drawer: _buildDrawer(context, name, email, imageUrl),
      appBar: AppBar(
        title: const Text("Student Panel", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 150,
            child: Image.network("$apiUrl/banner.jpg", fit: BoxFit.cover),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildCard(context, Colors.pink, Icons.person, "Class Routine", ShowClassRoutine()),
                _buildCard(context, Colors.teal, Icons.school, "Exam Schedule", const ShowExamSchedule()),
                _buildCard(context, Colors.deepOrange, Icons.group, "Attendance", const SearchId()),
                _buildCard(context, Colors.deepPurple, Icons.attach_money, "Mark Submission", const CalculateMarksPage()),
                _buildCard(context, Colors.brown, Icons.report, "Report Card", StudentResultPage()),
                _buildCard(
                  context,
                  Colors.lightBlueAccent,
                  Icons.notification_important,
                  "Notice",
                  null,
                  fallback: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notice section coming soon.')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home, size: 30),
        tooltip: 'Go to Home',
        onPressed: () => _navigateTo(context, MyHomePage(title: 'Home')),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, String name, String email, String imageUrl) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, fit: BoxFit.cover)
                    : const Image(image: AssetImage("images/PA.png")),
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
          _buildDrawerItem(Icons.home, 'Home', () => _navigateTo(context, MyHomePage(title: 'Home'))),
          _buildDrawerItem(Icons.person, 'Student', () {}),
          _buildDrawerItem(Icons.call, 'Contact', () {}),
          _buildDrawerItem(Icons.email, 'Email Address', () {}),
          _buildDrawerItem(Icons.settings, 'Settings', () {}),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _buildCard(BuildContext context, Color color, IconData icon, String label, Widget? targetPage, {VoidCallback? fallback}) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.3),
        onTap: () {
          if (targetPage != null) {
            _navigateTo(context, targetPage);
          } else if (fallback != null) {
            fallback();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}
