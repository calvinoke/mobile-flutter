import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/session_manager.dart';
import 'package:mobile/login.dart';
import 'package:mobile/dashboard.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionManager>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal,
        actions: [
          if (session.loggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                session.logout(); // You should define this in SessionManager
              },
            ),
        ],
      ),
      body: session.loggedIn
          ? const DashboardScreen() // Replace with your home screen after login
          : const LoginScreen(),
    );
  }
}