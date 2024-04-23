import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/admin/hostel.dart';
import 'package:hostel_hive/pages/sign_in_page.dart';
import 'package:hostel_hive/pages/user/home_page.dart';
import 'package:hostel_hive/pages/user/profile_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // get the current user
  final user = FirebaseAuth.instance.currentUser!;

  Future signOut() async {
    await FirebaseAuth.instance.signOut().then(
          (value) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
          ),
        );
  }
  
  void alertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to Sign Out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 2,
        shadowColor: Colors.black,
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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // get user data
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  // get profile picture url
                  final profilePictureUrl = userData['profilePictureUrl'];

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.green[700],
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: profilePictureUrl != null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(profilePictureUrl),
                                )
                              : const DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('assets/images/profile.jpg'),
                                ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green[400],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),

      // Navigation bar
      drawer: Drawer(
        backgroundColor: Colors.grey[100],
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
                Navigator.push(
                  context,
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

            // logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: alertDialog,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageHostelsPage(),
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
                      image: AssetImage('assets/images/img1.jpg'),
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
                          'Manage Hostels',
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
