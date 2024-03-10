import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/home_page.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool isObscure = true;
  bool isEmailValid = true;

  // Sign In Function
  void signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
        .then(
          (value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          ),
        );
  }

  // Email & Password validations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 250,
                  height: 200,
                ),

                // Sign In Text
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 20,
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
                  height: 20,
                ),

                // Sign In button
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signIn,
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
                      'Sign In',
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
                      "Don't have an account? ",
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
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
        ),
      ),
    );
  }
}
