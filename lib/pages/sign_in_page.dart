import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/admin/admin_home_page.dart';
import 'package:hostel_hive/pages/password_reset_page.dart';
import 'package:hostel_hive/pages/sign_up_page.dart';
import 'package:hostel_hive/pages/user/home_page.dart';
import 'package:hostel_hive/services/auth_service.dart';

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
  bool isAdminUser = false;

  // Sign In Function
  Future signIn() async {
    // loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 60, 255, 0),
          ),
        );
      },
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      popCircularIndicator();

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        if (userData is Map<String, dynamic> &&
            userData.containsKey('isAdmin')) {
          isAdminUser = userData['isAdmin'] ?? false;

          // navigate to home page
          navigateToHomePage();
        }
      }
    } catch (e) {
      popCircularIndicator();

      if (e is FirebaseAuthException) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'User not found';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password';
            break;
          default:
            errorMessage = 'Error signing in';
        }

        _showErrorDialog(errorMessage);
      } else {
        _showErrorDialog('Failed to sign in');
      }
    }
  }

  // pop the circular indicator
  void popCircularIndicator() {
    Navigator.pop(context);
  }

  // navigate to Home page
  void navigateToHomePage() {
    if (isAdminUser) {
      // Navigate to admin home page if the user is an admin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminHomePage(),
        ),
      );
    } else {
      // Navigate to regular user home page if the user is not an admin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  // alert dialog
  void _showErrorDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(title)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    height: 160,
                  ),
                ),

                // Sign In Heading
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Sign in to continue exploring',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),

                const SizedBox(height: 32),

                // Email TextField
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    errorText: isEmailValid ? null : 'Invalid email format',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() {
                    isEmailValid = emailRegExp.hasMatch(value) || value.isEmpty;
                  }),
                ),

                const SizedBox(height: 16),

                // Password TextField
                TextField(
                  controller: passwordController,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() {
                        isObscure = !isObscure;
                      }),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPassword(),
                        ),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: signIn,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Divider with text
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                            color:
                                Theme.of(context).colorScheme.outlineVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or continue with',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                            color:
                                Theme.of(context).colorScheme.outlineVariant)),
                  ],
                ),

                const SizedBox(height: 24),

                // Social Login Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Button
                    InkWell(
                      onTap: () => AuthService().signInWithGoogle(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/images/googlelogo.png',
                          scale: 2,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Facebook Button
                    InkWell(
                      onTap: () => AuthService().signInWithFacebook(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/images/fblogo.png',
                          scale: 2,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.w600),
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
