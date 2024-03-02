import 'package:flutter/material.dart';
import 'map_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        // Logo
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
          ),
        ),

        // Profile picture
        actions:  [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                  radius: 20),
            ),
          ),
        ],
      ),

      // Navigation
      drawer: Drawer(
        backgroundColor: Colors.green[100],
        child: ListView(
          children: [
            // Logo
            DrawerHeader(
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),

            // Home
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),

            // Profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),

            // About
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MapPage(),
                  ),
                );
                },
                child: Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/map.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Find Place',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
