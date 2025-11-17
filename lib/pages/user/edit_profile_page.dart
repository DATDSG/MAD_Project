import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/sign_in_page.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Uint8List? pickedImage;
  String? profilePictureUrl;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');
  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool isEmailValid = true;

  // update user details
  Future updateUserDetails() async {
    // update name
    if (nameController.text.isNotEmpty) {
      updateName();

      // update success alert box
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Success'),
            content: const Text('Your details have been updated'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      setState(() {
        nameController.clear();
      });
    }

    // update contact number
    if (contactNumberController.text.isNotEmpty) {
      updateContactNumber();

      // update success alert box
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Success'),
            content: const Text('Your details have been updated'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      setState(() {
        contactNumberController.clear();
      });
    }
  }

  // delete profile
  Future deleteAccount() async {
    signOut();
    deletedAlertDialog();

    await currentUser.delete();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .delete();
  }

  // change password
  Future changePassword() async {
    updatePassword();

    // password change email sent success alert box
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Done'),
          content: const Text('Your password change Email sent!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    setState(() {
      emailController.clear();
    });
  }

  // update name
  Future updateName() async {
    await userCollection.doc(currentUser.email).update({
      'name': nameController.text,
    });
  }

  // update contact number
  Future updateContactNumber() async {
    await userCollection.doc(currentUser.email).update({
      'contactNumber': contactNumberController.text,
    });
  }

  // change password
  Future updatePassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: currentUser.email!,
    );
  }

  void passwordChangeAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: const Text('Are you sure you want to change your password?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Change Password'),
              onPressed: () {
                Navigator.of(context).pop();
                changePassword();
              },
            ),
          ],
        );
      },
    );
  }

  // update profile picture
  // Pick image from device
  Future<void> changeProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    // Upload image to firebase storage
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('profile_pictures/${currentUser.email}');
    final imageBytes = await image.readAsBytes();
    await imageRef.putData(imageBytes);

    setState(() {
      pickedImage = imageBytes;
    });

    // Update profile picture URL in Firestore database
    final imageUrl = await imageRef.getDownloadURL();
    await userCollection.doc(currentUser.email).update({
      'profilePictureUrl': imageUrl,
    });
  }

  // Get profile picture form firestore database
  Future<void> getProfilePicture() async {
    final userData = await userCollection.doc(currentUser.email).get();
    final imageUrl = userData['profilePictureUrl'];

    if (imageUrl != null) {
      setState(() {
        profilePictureUrl = imageUrl;
      });
    }
  }

  // alert dialog
  void alertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  // successfully deleted alrert dialog
  void deletedAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Text('Your Account successfully Deleted!'),
        );
      },
    );
  }

  // Navigate to the sign in page
  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInPage(),
      ),
    );
  }

  @override
  void initState() {
    getProfilePicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // get user data
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                // Profile Picture
                Center(
                  child: GestureDetector(
                    onTap: changeProfilePicture,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: ClipOval(
                            child: pickedImage != null
                                ? Image.memory(
                                    pickedImage!,
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  )
                                : profilePictureUrl != null
                                    ? Image.network(
                                        userData['profilePictureUrl'],
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'assets/images/profile.jpg',
                                          fit: BoxFit.cover,
                                          width: 120,
                                          height: 120,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/images/profile.jpg',
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 120,
                                      ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Name Field
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: userData['name'],
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Contact Number Field
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Number',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: contactNumberController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: userData['contactNumber'],
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                FilledButton(
                  onPressed: updateUserDetails,
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 12),

                // Change Password Section
                Text(
                  'Security',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                // Change Password Button
                FilledButton(
                  onPressed: passwordChangeAlertDialog,
                  child: const Text('Change Password'),
                ),
                const SizedBox(height: 24),

                // Delete Account Button
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: alertDialog,
                  child: const Text('Delete Account'),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
