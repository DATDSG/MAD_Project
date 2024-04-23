import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_hive/pages/sign_in_page.dart';
import 'package:hostel_hive/pages/user/home_page.dart';
import 'package:hostel_hive/pages/admin/admin_home_page.dart'; // Import the admin home page

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              color: Colors.green,
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (snapshot.hasData) {
              User? user = snapshot.data;

              if (user != null) {
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(user.email)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Colors.green,
                      );
                    } else if (userSnapshot.hasError) {
                      return Text('Error: ${userSnapshot.error}');
                    } else {
                      bool isAdmin = userSnapshot.data?.get('isAdmin') ?? false;
                      if (isAdmin) {
                        return const AdminHomePage();
                      } else {
                        return const HomePage();
                      }
                    }
                  },
                );
              } else {
                return const SignInPage();
              }
            } else {
              return const SignInPage();
            }
          }
        },
      ),
    );
  }
}
