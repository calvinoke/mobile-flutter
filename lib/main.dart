
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:school_management/adminpanel.dart';
import 'package:school_management/admissionform.dart';
import 'package:school_management/model_class/Alluser.dart';
import 'package:school_management/model_class/ipAddress.dart';
import 'package:school_management/newapplicants.dart';
import 'package:school_management/signup.dart';
import 'package:school_management/studentpanel.dart';
import 'package:school_management/teacherpanel.dart';

List<Alluser> objectsFromJson(String str) =>
    List<Alluser>.from(json.decode(str).map((x) => Alluser.fromJson(x)));
String objectsToJson(List<Alluser> data) =>
    json.encode(List<Alluser>.from(data).map((x) => x.toJson()));

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'School Management'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future<Alluser> allUserLogin() async {
    Alluser s = Alluser(
        username: "",
        name: "",
        email: _email.text,
        password: _password.text,
        image: "",
        role: "");
          Ip ip =Ip();
    final response = await http.post(
        Uri.parse(ip.ipAddress+'/loginadmin'),
        body: jsonEncode(s.toJson()),
        headers: {"content-type": "application/json"});

    if (response.statusCode == 200) {
      return Alluser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Text(
                "Welcome to Your School",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  child: Text('Online Admission', style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Admissionform()));
                  }),
              SizedBox(height: 49,),
              Padding(
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email,color: Colors.teal,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock,color: Colors.teal,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () async {
                  Alluser s = await allUserLogin();
                  if (s != null &&
                      (s.email == _email.text) &&
                      (s.password == _password.text)) {
                    if (s.role == 'admin') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Adminpanel()));
                    } else if (s.role == 'teacher') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Teacherpanel()));
                    } else if (s.role == 'student') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Studentpanel()));
                    } else {
                      SnackBar snk =
                          SnackBar(content: Text('Enter correct information'));
                      ScaffoldMessenger.of(context).showSnackBar(snk);
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  child: Text('Signup'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
