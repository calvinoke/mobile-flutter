import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management/adminpanel.dart';
import 'package:school_management/main.dart';
import 'package:school_management/model_class/Alluser.dart';
import 'package:school_management/model_class/ipAddress.dart';
import 'package:school_management/studenttable.dart';

List<Alluser> objectsFromJson(String str) =>
    List<Alluser>.from(json.decode(str).map((x) => Alluser.fromJson(x)));
String objectsToJson(List<Alluser> data) =>
    json.encode(List<Alluser>.from(data).map((x) => x.toJson()));

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _username = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _image = TextEditingController();
  TextEditingController _role = TextEditingController();

  Future<Alluser?> allUserSignup() async {
    Alluser s = Alluser(
      username: _username.text,
      name: _name.text,
      email: _email.text,
      password: _password.text,
      image: _image.text,
      role: _role.text,
    );
   Ip ip = Ip();
    final response = await http.post(
      Uri.parse(ip.ipAddress+'/save'),
      body: jsonEncode(s.toJson()),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return Alluser.fromJson(jsonDecode(response.body));
    } else {
      print("Failed to sign up. Status code: ${response.statusCode}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Form(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person,color: Colors.blue,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.check_circle,color: Colors.blue,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email,color: Colors.blue,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock,color: Colors.blue,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  obscureText: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  controller: _image,
                  decoration: InputDecoration(
                    labelText: 'Image',
                    prefixIcon: Icon(Icons.image,color: Colors.blue,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  controller: _role,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    prefixIcon: Icon(Icons.post_add,color: Colors.blue,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              ElevatedButton(
                child: Text('Sign Up'),
                onPressed: () async {
                  if (_username.text.isEmpty ||
                      _name.text.isEmpty ||
                      _email.text.isEmpty ||
                      _password.text.isEmpty ||
                      _image.text.isEmpty ||
                      _role.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  Alluser? newUser = await allUserSignup();

                  if (newUser != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign up successful')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign up failed')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


