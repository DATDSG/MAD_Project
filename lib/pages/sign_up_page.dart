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
      // Show loading circle
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ));
        },
      );

      // Trim input values to prevent whitespace issues
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      final String name = nameController.text.trim();
      final String contactNumber = contactNumberController.text.trim();

      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verify user was created
      if (userCredential.user == null) {
        if (mounted) {
          popLoadingCircle();
          _showErrorDialog('Failed to create user account. Please try again.');
        }
        return;
      }

      // Add user details to database
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'name': name,
        'email': email,
        'contactNumber': contactNumber,
        'isAdmin': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Check if widget is still mounted before popping
      if (mounted) {
        popLoadingCircle();
        // Navigate to home page after successful sign-up
        navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        popLoadingCircle();
        String errorMessage = 'Failed to sign up. Please try again.';

        if (e.code == 'weak-password') {
          errorMessage =
              'The password provided is too weak. Please use a stronger password.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage =
              'An account with this email already exists. Please sign in instead.';
        } else if (e.code == 'invalid-email') {
          errorMessage =
              'The email address is invalid. Please check and try again.';
        } else if (e.code == 'operation-not-allowed') {
          errorMessage =
              'Email/password accounts are not enabled. Please contact support.';
        }

        _showErrorDialog(errorMessage);
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        popLoadingCircle();
        _showErrorDialog(
            'Database error: ${e.message ?? 'Unknown error occurred.'}');
      }
    } catch (e) {
      if (mounted) {
        popLoadingCircle();
        _showErrorDialog('An unexpected error occurred. Please try again.');
      }
    }
  }

  // pop loding circle
  void popLoadingCircle() {
    Navigator.pop(context);
  }

  bool validateFields() {
    // Check empty fields
    if (nameController.text.trim().isEmpty) {
      _showErrorDialog('Name cannot be empty');
      return false;
    }

    if (nameController.text.trim().length < 2) {
      _showErrorDialog('Name must be at least 2 characters long');
      return false;
    }

    // Email validation
    if (!emailRegExp.hasMatch(emailController.text.trim())) {
      _showErrorDialog('Please enter a valid email address');
      return false;
    }

    // Password validation
    if (passwordController.text.isEmpty) {
      _showErrorDialog('Password cannot be empty');
      return false;
    }

    if (passwordController.text.length < 6) {
      _showErrorDialog('Password must be at least 6 characters long');
      return false;
    }

    if (confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Please confirm your password');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return false;
    }

    // Phone number validation
    if (!contactNumberRegex.hasMatch(contactNumberController.text)) {
      _showErrorDialog('Please enter a valid 10-digit phone number');
      return false;
    }

    // Terms and conditions
    if (isChecked != true) {
      _showErrorDialog('Please accept the terms and conditions');
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 24),

          // Logo
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 160,
              height: 160,
            ),
          ),

          const SizedBox(height: 24),

          // Heading
          Text(
            'Create Account',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Join us to find your perfect hostel',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // Name Field
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),

          const SizedBox(height: 16),

          // Email Field
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

          // Contact Number
          TextField(
            controller: contactNumberController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone_outlined),
              errorText: isValidContactNumber ? null : 'Invalid phone number',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() {
              isValidContactNumber =
                  contactNumberRegex.hasMatch(value) || value.isEmpty;
            }),
          ),

          const SizedBox(height: 16),

          // Password Field
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

          const SizedBox(height: 8),

          // Password Requirements Hint
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Password must be 8+ characters with uppercase, lowercase, and special characters',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue[700],
                  ),
            ),
          ),

          const SizedBox(height: 16),

          // Confirm Password Field
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
              errorText: isPasswordMatch ? null : 'Passwords do not match',
            ),
            onChanged: (value) => setState(() {
              isPasswordMatch =
                  value == passwordController.text || value.isEmpty;
            }),
          ),

          const SizedBox(height: 20),

          // Terms and Conditions Checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (value) => setState(() {
                  isChecked = value ?? false;
                }),
              ),
              Expanded(
                child: Text(
                  'I agree to the Terms and Conditions',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Sign Up Button
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: signUp,
              child: const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Sign In Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignInPage(),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
