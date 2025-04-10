import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:school_management/model_class/Onlineadmission.dart';
import 'package:school_management/model_class/ipAddress.dart';




List<Onlineadmission> objectsFromJson(String str) => List<Onlineadmission>.from(
    json.decode(str).map((x) => Onlineadmission.fromJson(x)));
String objectsToJson(List<Onlineadmission> data) =>
    json.encode(List<Onlineadmission>.from(data).map((x) => x.toJson()));


class Newapplicants extends StatefulWidget {
  const Newapplicants({super.key});

  @override
  State<Newapplicants> createState() => _NewapplicantsState();
}

class _NewapplicantsState extends State<Newapplicants> {


  Future<List<Onlineadmission>> showallstudent() async {
   Ip ip = Ip();
    final response =
    await http.get(Uri.parse(ip.ipAddress+'/newapplicant'));
    if (response.statusCode == 200) {
      return objectsFromJson(response.body);
    } else {
      throw Exception("Failed");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student List"),
        backgroundColor: Colors.pink,
      ),

      body: ListView(
        children: [
          Container(

            width: double.infinity,

            child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYxmHcP_1VXwCa6C2w6JQmSP1k_Ut70OwZdQ&s"),
          ),
          Container(
            height: 700,
            child: FutureBuilder<List<Onlineadmission>>(
              future: showallstudent(),
              builder: (context, snapshot) {
                // _alldata=snapshot.data!;
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, index) {
                      return Center(
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),

                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 50,
                          shadowColor: Colors.black,
                          color: Colors.white,
                          child: SizedBox(
                            width: 350,
                            height: 650,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Column(
                                children: <Widget>[

                                  CircleAvatar(
                                    radius: 100,
                                    backgroundImage: NetworkImage(snapshot.data![index].image.toString()),

                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Registration ID : ' +
                                        snapshot.data![index].reg_no
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Full Name : ' +
                                        snapshot.data![index].full_name
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Date of Birth : ' +
                                        snapshot.data![index].dob.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Email : ' +
                                        snapshot.data![index].email.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Mobile : ' +
                                        snapshot.data![index].mob.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Gender : ' +
                                        snapshot.data![index].gender.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Class : ' +
                                        snapshot.data![index].class1.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Session : ' +
                                        snapshot.data![index].section
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 15,

                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Present_address : ' +
                                        snapshot.data![index].present_address.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'permanent_address : ' +
                                        snapshot.data![index].permanent_address
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Permanent_address : ' +
                                        snapshot.data![index].permanent_address
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Session : ' +
                                        snapshot.data![index].session
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Username : ' +
                                        snapshot.data![index].username
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Password : ' +
                                        snapshot.data![index].password
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Error");
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}



