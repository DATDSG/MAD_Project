import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/user/home_page.dart';
import 'package:hostel_hive/pages/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp contactNumberRegex = RegExp(r'^[1-9][0-9]{8}$|^0[0-9]{9}$');

  bool isObscure = true;
  bool isEmailValid = true;
  bool isChecked = false;
  bool isPasswordMatch = true;
  bool isValidContactNumber = true;

  // Sign Up Function
  Future signUp() async {
    // Validate form fields
    if (!validateFields()) {
      return;
    }

    try {
      // loding circle
      showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.green[400],
          ));
        },
      );

      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Add user details to database
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'name': nameController.text,
        'contactNumber': contactNumberController.text,
        'isChecked': isChecked,
        'isAdmin': false,
      });

      popLoadingCircle();

      // Navigate to home page after successful sign-up
      navigateToHome();
    } catch (e) {
      _showErrorDialog('Failed to sign up. Please try again.');
    }
  }

  // pop loding circle
  void popLoadingCircle() {
    Navigator.pop(context);
  }

  bool validateFields() {
    if (nameController.text.isEmpty ||
        !emailRegExp.hasMatch(emailController.text) ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        !contactNumberRegex.hasMatch(contactNumberController.text)) {
      _showErrorDialog('Please fill all fields correctly.');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match.');
      return false;
    }

    return true;
  }

  // alert box
  void _showErrorDialog(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          )),
        );
      },
    );
  }

  // navigate to Home page
  void navigateToHome() {
    if (isChecked) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 250,
                    height: 250,
                  ),
                ),

                // Sign Up Text
                const Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // Email address
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isEmailValid ? Colors.green : Colors.red,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() {
                    isEmailValid = emailRegExp.hasMatch(value);
                  }),
                ),

                const SizedBox(
                  height: 10,
                ),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() {
                        isObscure = !isObscure;
                      }),
                      child: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // Confirm Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isPasswordMatch ? Colors.green : Colors.red,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    isPasswordMatch = value == passwordController.text;
                  }),
                ),

                const SizedBox(
                  height: 10,
                ),

                // Contact Number
                TextField(
                  controller: contactNumberController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isValidContactNumber ? Colors.green : Colors.red,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                    hintText: 'Contact Number',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() {
                    isValidContactNumber = contactNumberRegex.hasMatch(value);
                  }),
                ),

                // Check Box - admin sign up
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked,
                      fillColor: MaterialStateColor.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.green;
                        }
                        return Colors.white;
                      }),
                      onChanged: (value) => setState(() {
                        isChecked = !isChecked;
                      }),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'I Agree Terms and Conditions',
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // Sign Up button
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signUp,
                    style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(Colors.grey),
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 58, 237, 124),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Sign In text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
