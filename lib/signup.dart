import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/model_class/Alluser.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/main.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _image = TextEditingController();
  final TextEditingController _role = TextEditingController();

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      Alluser newUser = Alluser(
        username: _username.text,
        name: _name.text,
        email: _email.text,
        password: _password.text,
        image: _image.text,
        role: _role.text,
      );

      final user = await userProvider.signup(newUser);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed up as ${user.role}, confirmation email sent.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Login')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              _buildTextField(
                controller: _username,
                label: 'Username',
                icon: Icons.person,
                validator: (value) => value!.isEmpty ? 'Username is required' : null,
              ),
              _buildTextField(
                controller: _name,
                label: 'Name',
                icon: Icons.check_circle,
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              _buildTextField(
                controller: _email,
                label: 'Email',
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              _buildTextField(
                controller: _password,
                label: 'Password',
                icon: Icons.lock,
                obscure: true,
                validator: (value) =>
                    value != null && value.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
              _buildTextField(
                controller: _image,
                label: 'Image URL',
                icon: Icons.image,
                validator: (value) => value!.isEmpty ? 'Image URL is required' : null,
              ),
              _buildTextField(
                controller: _role,
                label: 'Role',
                icon: Icons.post_add,
                validator: (value) => value!.isEmpty ? 'Role is required' : null,
              ),
              ElevatedButton(
                onPressed: _handleSignup,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
