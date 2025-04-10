import 'package:flutter/material.dart';
import 'package:school_management/PaymentRecordsPage.dart';
import 'package:school_management/ShowClassRoutine.dart';
import 'package:school_management/main.dart';
import 'package:school_management/StudentResultPage.dart';
import 'package:school_management/showAttendanceById.dart';
import 'package:school_management/showStudentAttendance.dart';
import 'package:school_management/showexamschedule.dart';

class Studentpanel extends StatefulWidget {
  const Studentpanel({super.key});

  @override
  State<Studentpanel> createState() => _StudentpanelState();
}

class _StudentpanelState extends State<Studentpanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Tanzila Rahman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail: Text('tanzila@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset("images/PA.png", fit: BoxFit.cover),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            _buildDrawerItem(
                icon: Icons.home,
                text: 'Home',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                }),
            _buildDrawerItem(
                icon: Icons.person,
                text: 'Student',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                }),
            _buildDrawerItem(
                icon: Icons.call,
                text: 'Contact',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                }),
            _buildDrawerItem(
                icon: Icons.email,
                text: 'Email Address',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                }),
            _buildDrawerItem(
                icon: Icons.settings,
                text: 'Settings',
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                }),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Student Panel",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            child: Image.network(
              "https://media.licdn.com/dms/image/D4D12AQGMSihfr5huBA/article-cover_image-shrink_600_2000/0/1701765450293?e=2147483647&v=beta&t=qdl-19jQLxdP0crlAibXI675XTAck_uhvswf9fO5cAg",
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(8),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: <Widget>[
                _buildCard(
                    color: Colors.pink,
                    icon: Icons.person,
                    label: "Class Routine",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowClassRoutine()));
                    }),
                _buildCard(
                    color: Colors.teal,
                    icon: Icons.school,
                    label: "Exam Schedule",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Showexamschedule()));
                    }),
                _buildCard(
                    color: Colors.deepOrange,
                    icon: Icons.group,
                    label: "Attendance",
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SearchId()));
                    }),
                _buildCard(
                    color: Colors.deepPurple,
                    icon: Icons.attach_money,
                    label: "Fee Submission",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalculateFeesPage()));
                    }),
                _buildCard(
                    color: Colors.brown,
                    icon: Icons.report,
                    label: "Report Card",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentResultPage()));

                    }),
                _buildCard(
                    color: Colors.lightBlueAccent,
                    icon: Icons.notification_important,
                    label: "Notice",
                    onTap: () {
                      // Add navigation action if needed
                    }),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home, size: 30),
        tooltip: 'Go to Home',
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        },
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _buildCard({
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.3),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.white, size: 32),
              SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
