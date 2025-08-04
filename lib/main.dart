import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'model_class/Alluser.dart';
import 'providers/user_provider.dart';
import 'providers/session_manager.dart';

// Screens
import 'login.dart';
import 'signup.dart'; // Import your Signup screen here
import 'dashboard.dart'; // Your Dashboard screen

// Other providers
import 'providers/attendance_provider.dart';
import 'providers/student_provider.dart';
import 'providers/result_provider.dart';
import 'providers/student_profile_provider.dart';
import 'providers/exam_form_provider.dart';
import 'providers/exam_schedule_provider.dart';
import 'providers/class_routine_provider.dart';
import 'providers/fees_provider.dart';
import 'providers/new_applicants_provider.dart';
import 'providers/marks_provider.dart';
import 'providers/admission_form_provider.dart';
import 'providers/admin_pannel_provider.dart';

List<Alluser> objectsFromJson(String str) =>
    List<Alluser>.from(json.decode(str).map((x) => Alluser.fromJson(x)));

String objectsToJson(List<Alluser> data) =>
    json.encode(data.map((x) => x.toJson()).toList());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionManager()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
        ChangeNotifierProvider(create: (_) => StudentProfileProvider()),
        ChangeNotifierProvider(create: (_) => ExamFormProvider()),
        ChangeNotifierProvider(create: (_) => ExamScheduleProvider()),
        ChangeNotifierProvider(create: (_) => ClassRoutineProvider()),
        ChangeNotifierProvider(create: (_) => FeesProvider()),
        ChangeNotifierProvider(create: (_) => NewApplicantsProvider()),
        ChangeNotifierProvider(create: (_) => MarksProvider()),
        ChangeNotifierProvider(create: (_) => AdmissionFormProvider()),
        ChangeNotifierProvider(create: (_) => AdminPanelProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'School Management System'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionManager>();

    if (session.loggedIn) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const DashboardScreen(),
      );
    } else {
      // Show buttons to navigate to Login or Signup
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Signup()),
                  );
                },
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
