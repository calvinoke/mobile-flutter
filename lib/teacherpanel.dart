import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

import 'package:share_plus/share_plus.dart';

import 'package:mobile/providers/session_manager.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/login.dart';

class Teacherpanel extends StatefulWidget {
  final String userName;
  final String userEmail;

  const Teacherpanel({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<Teacherpanel> createState() => _TeacherpanelState();
}

class _TeacherpanelState extends State<Teacherpanel> {
  bool _isLoggingOut = false;
  File? _selectedImage;
  List<String> courses = [];
  List<String> students = [];
  Map<String, int> performance = {};

  @override
  void initState() {
    super.initState();
    _loadImageFromPrefs();
    _loadDashboardData();
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      await Provider.of<SessionManager>(context, listen: false).clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('teacher_image', pickedFile.path);
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('teacher_image');
    if (path != null && File(path).existsSync()) {
      setState(() {
        _selectedImage = File(path);
      });
    }
  }

  Future<void> _loadDashboardData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchTeacherDashboard();

    final dashboard = userProvider.dashboard;

    setState(() {
      courses = dashboard.courses.map((c) => c.name).toList();
      students = dashboard.students.map((s) => s.name).toList();

      performance = {};
      for (var course in dashboard.courses) {
        performance[course.name] = (50 + (course.name.length * 7)) % 100;
      }

      if (performance.isEmpty) {
        performance = {'Math': 80, 'Science': 90, 'English': 70};
      }
    });
  }

  Future<File> _createPdfFile(pw.Document pdf) async {
    final outputDir = await getTemporaryDirectory();
    final file = File('${outputDir.path}/report_card.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _generateAndSharePdf() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Student Report Card', style: pw.TextStyle(fontSize: 24))),
          pw.Text('Name: ${user?.name ?? "N/A"}'),
          pw.Text('Email: ${user?.email ?? "N/A"}'),
          pw.SizedBox(height: 16),

          pw.Text('Courses:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
          courses.isNotEmpty
              ? pw.Bullet(text: courses.join(', '))
              : pw.Text('No courses'),

          pw.SizedBox(height: 12),

          pw.Text('Students:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
          students.isNotEmpty
              ? pw.Column(children: students.map((s) => pw.Text('- $s')).toList())
              : pw.Text('No students'),

          pw.SizedBox(height: 20),

          pw.Text('Performance Overview:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
          pw.SizedBox(height: 10),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: performance.entries
                .map((entry) => pw.Text('${entry.key}: ${entry.value}%'))
                .toList(),
          ),
        ],
      ),
    );

    final file = await _createPdfFile(pdf);
    await Printing.layoutPdf(onLayout: (format) => pdf.save());

    final directory = await getApplicationDocumentsDirectory();
    final savedFile = await file.copy('${directory.path}/report_card_${DateTime.now().millisecondsSinceEpoch}.pdf');

    await Share.shareXFiles([XFile(savedFile.path)], text: 'Student Report Card PDF');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.userName}"),
        backgroundColor: Colors.pinkAccent,
      ),
      drawer: _buildDrawer(widget.userName, widget.userEmail),
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

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          if (_selectedImage != null)
            Image.file(_selectedImage!, height: 150),
          const SizedBox(height: 20),

          Text("Courses:", style: Theme.of(context).textTheme.titleLarge),
          ...courses.map((course) => ListTile(title: Text(course))),
          const SizedBox(height: 20),

          Text("Students:", style: Theme.of(context).textTheme.titleLarge),
          ...students.map((student) => ListTile(title: Text(student))),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("Generate & Share PDF Report"),
            onPressed: _generateAndSharePdf,
          ),
          const SizedBox(height: 20),

          Text("Performance Overview:", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(
            height: 200,
            child: charts.BarChart(
              [
                charts.Series<int, String>(
                  id: 'Performance',
                  data: performance.values.toList(),
                  domainFn: (val, index) => performance.keys.toList()[index!],
                  measureFn: (val, _) => val,
                  colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                )
              ],
              animate: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(String name, String email) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
              child: _selectedImage == null
                  ? const Icon(Icons.person, size: 40, color: Colors.pinkAccent)
                  : null,
            ),
            decoration: const BoxDecoration(color: Colors.pinkAccent),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Upload Photo'),
            onTap: _pickImage,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
