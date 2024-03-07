import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/*await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}


