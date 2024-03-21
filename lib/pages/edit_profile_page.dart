import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  // final TextEditingController newPasswordController = TextEditingController();
  // final TextEditingController confirmNewPasswordController =TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');
  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // bool isObscure = true;
  // bool isPasswordMatch = true;
  bool isEmailValid = true;

  // update user details
  Future updateUserDetails() async {
    // update name
    if (nameController.text.isNotEmpty) {
      await userCollection.doc(currentUser.email).update({
        'name': nameController.text,
      });

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
      await userCollection.doc(currentUser.email).update({
        'contactNumber': contactNumberController.text,
      });

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

  // change password
  Future changePassword() async {
    if (emailController.text == currentUser.email) {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );

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
    } else {
      // show error alert box
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid Email'),
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
    }
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
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      children: [
                        // profile picture
                        const Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('assets/images/profile.jpg'),
                          ),
                        ),

                        // change profile picture button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Change Profile Picture',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
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
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 10),
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

                        // Email address
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 5),
                        //   child: Container(
                        //     width: double.infinity,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       color: Colors.white,
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.black.withOpacity(0.1),
                        //           spreadRadius: 1,
                        //           blurRadius: 2,
                        //           offset: const Offset(0, 2),
                        //         ),
                        //       ],
                        //     ),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Padding(
                        //           padding: EdgeInsets.only(top: 10, left: 20),
                        //           child: Text(
                        //             "Email Address",
                        //             style: TextStyle(
                        //               fontSize: 17,
                        //               fontWeight: FontWeight.w500,
                        //             ),
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.only(
                        //               left: 20, bottom: 10),
                        //           child: SizedBox(
                        //             height: 25,
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(right: 10),
                        //               child: TextField(
                        //                 controller: emailController,
                        //                 decoration: InputDecoration(
                        //                   hintText: currentUser.email,
                        //                   hintStyle: TextStyle(
                        //                     fontSize: 15,
                        //                     color: Colors.grey[700],
                        //                   ),
                        //                   border: const UnderlineInputBorder(
                        //                     borderSide: BorderSide(
                        //                       color: Colors.grey,
                        //                       width: 2,
                        //                     ),
                        //                   ),
                        //                   contentPadding:
                        //                       const EdgeInsets.only(bottom: 10),
                        //                 ),
                        //                 style: TextStyle(
                        //                   fontSize: 15,
                        //                   color: Colors.grey[700],
                        //                 ),
                        //                 keyboardType:
                        //                     TextInputType.emailAddress,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

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
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 10),
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

                        // New Password
                        // TextField(
                        //   controller: newPasswordController,
                        //   obscureText: isObscure,
                        //   decoration: InputDecoration(
                        //     contentPadding: const EdgeInsets.all(8),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //       borderSide: const BorderSide(
                        //         color: Colors.green,
                        //         width: 2,
                        //       ),
                        //     ),
                        //     prefixIcon: Icon(
                        //       Icons.lock,
                        //       size: 18,
                        //       color: Colors.grey[400],
                        //     ),
                        //     suffixIcon: GestureDetector(
                        //       onTap: () => setState(() {
                        //         isObscure = !isObscure;
                        //       }),
                        //       child: Icon(
                        //         isObscure
                        //             ? Icons.visibility_off
                        //             : Icons.visibility,
                        //         size: 18,
                        //         color: Colors.grey,
                        //       ),
                        //     ),
                        //     hintText: 'New Password',
                        //     hintStyle: TextStyle(
                        //       color: Colors.grey[400],
                        //     ),
                        //   ),
                        // ),

                        // email address
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.green,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.mail,
                              size: 18,
                              color: Colors.grey[400],
                            ),
                            hintText: 'Email address',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                          ),
                          onChanged: (value) => setState(() {
                            isEmailValid = emailRegExp.hasMatch(value);
                          }),
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
          }),
    );
  }
}
