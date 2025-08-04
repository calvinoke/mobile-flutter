import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/admin_pannel_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/main.dart';

class Adminpanel extends StatefulWidget {
  const Adminpanel({super.key});

  @override
  State<Adminpanel> createState() => _AdminpanelState();
}

class _AdminpanelState extends State<Adminpanel> {
  int hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final panelItems = Provider.of<AdminPanelProvider>(context).items;

    // Get user info from provider (adjust based on your actual user provider)
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user; // Assuming user object has name, email, image

    return Scaffold(
      drawer: _buildDrawer(user),
      appBar: AppBar(
        title: const Text("Welcome to Admin Panel"),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUmMCmQcHYBJ5u5oNSwibGuM4XCJiwY8BJXORfS1P7Ve9gw0ikNy1cujPl28_nCtT9GGw&usqp=CAU",
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                int crossAxisCount;
                double fontSize;
                double iconSize;

                if (width > 1000) {
                  crossAxisCount = 4;
                  fontSize = 14;
                  iconSize = 40;
                } else if (width > 600) {
                  crossAxisCount = 3;
                  fontSize = 12;
                  iconSize = 35;
                } else {
                  crossAxisCount = 2;
                  fontSize = 10;
                  iconSize = 30;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: panelItems.length,
                  itemBuilder: (context, index) {
                    final item = panelItems[index];
                    final isHovered = index == hoveredIndex;

                    return MouseRegion(
                      onEnter: (_) => setState(() => hoveredIndex = index),
                      onExit: (_) => setState(() => hoveredIndex = -1),
                      child: Card(
                        color:
                            isHovered ? Colors.lightBlueAccent : item.cardColor,
                        elevation: isHovered ? 12 : 4,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => item.page),
                            );
                          },
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(item.icon,
                                    color: Colors.white, size: iconSize),
                                const SizedBox(height: 6),
                                Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        tooltip: 'Go to the previous page',
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MyApp()),
          );
        },
      ),
    );
  }

  Drawer _buildDrawer(user) {
    final menuItems = Provider.of<AdminPanelProvider>(context).items;  // <-- fixed here

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'Unknown User'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.image != null && user!.image.isNotEmpty
                  ? NetworkImage(user.image)
                  : const AssetImage("images/download.png") as ImageProvider,
            ),
            decoration: const BoxDecoration(
              color: Colors.pinkAccent,
              image: DecorationImage(
                image: AssetImage('images/cvpic.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ...menuItems.map(
            (item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item.page),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
