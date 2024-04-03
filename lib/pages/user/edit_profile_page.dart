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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 2,
        shadowColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Edit Profile',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
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
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      // profile picture
                      Center(
                        child: GestureDetector(
                          onTap: changeProfilePicture,
                          child: CircleAvatar(
                            radius: 59,
                            backgroundColor: Colors.green[400],
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                image: pickedImage != null
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: MemoryImage(
                                          pickedImage!,
                                        ),
                                      )
                                    : profilePictureUrl != null
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                userData['profilePictureUrl']),
                                          )
                                        : const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'assets/images/profile.jpg'),
                                          ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Name
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10, left: 20),
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, bottom: 10),
                                child: SizedBox(
                                  height: 25,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        hintText: userData['name'],
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.only(bottom: 10),
                                      ),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Contact Number
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10, left: 20),
                                child: Text(
                                  "Contact Number",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, bottom: 10),
                                child: SizedBox(
                                  height: 25,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: TextField(
                                      controller: contactNumberController,
                                      decoration: InputDecoration(
                                        hintText: userData['contactNumber'],
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.only(bottom: 10),
                                      ),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Save button
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: updateUserDetails,
                            style: ButtonStyle(
                              shadowColor:
                                  MaterialStateProperty.all(Colors.grey),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.green[400],
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // delete profile button
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: alertDialog,
                            style: ButtonStyle(
                              shadowColor:
                                  MaterialStateProperty.all(Colors.grey),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.red[400],
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Delete account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Change Password
                      const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // password change button
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: changePassword,
                            style: ButtonStyle(
                              shadowColor:
                                  MaterialStateProperty.all(Colors.grey),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.green[400],
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
