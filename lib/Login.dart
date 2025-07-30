import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/providers/session_manager.dart'; // Add your SessionManager import
import 'package:mobile/adminpanel.dart';
import 'package:mobile/admissionform.dart';
import 'package:mobile/signup.dart';
import 'package:mobile/studentpanel.dart';
import 'package:mobile/teacherpanel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final session = Provider.of<SessionManager>(context, listen: false);

    final success = await userProvider.login(
      email: _email.text.trim(),
      password: _password.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!success) {
      _showSnackbar("Login failed. Please check your credentials.");
      return;
    }

    // Save auth token or relevant data in session manager
    await session.set('auth_token', userProvider.user?.token ?? '');

    final user = userProvider.user;
    if (user == null || user.role == null) {
      _showSnackbar("Invalid user data. Try again.");
      return;
    }

    // Navigate based on role
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
            builder: (_) =>
                Teacherpanel(userName: user.username, userEmail: user.email),
          ),
        );
        break;
      case 'student':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Studentpanel(
                name: user.name, email: user.email, imageUrl: user.image),
          ),
        );
        break;
      default:
        _showSnackbar("Unknown user role. Please contact support.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionManager>();

    if (session.loggedIn) {
      // You can also fetch user info from UserProvider if needed for routing
      return Scaffold(
        body: Center(
          child: Text(
            "Already logged in",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    // Show login form when not logged in
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Welcome to Namugongo School",
                style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdmissionFormScreen()),
                ),
                child: const Text(
                  'Online Admission',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
              const SizedBox(height: 40),
              _buildInputField(
                controller: _email,
                label: 'Email',
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Email is required';
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value.trim())) {
                    return 'Enter a valid email';
                  }
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
                  if (value.trim().length < 8) return 'Password must be at least 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(onPressed: _handleLogin, child: const Text('Login')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Signup()));
                },
                child: const Text('Signup'),
              ),
            ],
          ),
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
