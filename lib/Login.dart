import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/providers/session_manager.dart';
import 'package:mobile/providers/student_profile_provider.dart';

import 'package:mobile/signup.dart';
import 'package:mobile/adminpanel.dart';
import 'package:mobile/studentpanel.dart';
import 'package:mobile/teacherpanel.dart';
import 'package:mobile/admissionform.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final session = Provider.of<SessionManager>(context, listen: false);
    final studentProfile = Provider.of<StudentProfileProvider>(context, listen: false);

    final success = await userProvider.login(
      email: _email.text.trim(),
      password: _password.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!success) {
      _showSnackbar("Login failed. Please check your credentials.");
      return;
    }

    await session.set('auth_token', userProvider.user?.token ?? '');

    final user = userProvider.user;
    if (user == null || user.role == null) {
      _showSnackbar("Invalid user data. Try again.");
      return;
    }

    switch (user.role) {
      case 'admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Adminpanel()),
        );
        break;

      case 'teacher':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Teacherpanel(
              userName: user.username,
              userEmail: user.email,
            ),
          ),
        );
        break;

      case 'student':
        studentProfile.setProfile(
          name: user.name,
          email: user.email,
          imageUrl: user.image,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Studentpanel()),
        );
        break;

      default:
        _showSnackbar("Unknown user role.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Welcome to Namugongo School",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdmissionFormScreen())),
              child: const Text('Online Admission', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 30),
            _buildInputField(
              controller: _email,
              label: 'Email',
              icon: Icons.email,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value.trim())) return 'Enter a valid email';
                return null;
              },
            ),
            _buildInputField(
              controller: _password,
              label: 'Password',
              icon: Icons.lock,
              obscure: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Password is required';
                if (value.trim().length < 8) return 'Min 8 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(onPressed: _handleLogin, child: const Text("Login")),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Signup())),
              child: const Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
