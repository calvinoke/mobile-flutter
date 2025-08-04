import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Welcome to the Dashboard!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

