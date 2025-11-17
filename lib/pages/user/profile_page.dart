import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/sign_in_page.dart';
import 'package:hostel_hive/pages/user/edit_profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //get current user
  final currentUser = FirebaseAuth.instance.currentUser!;

  bool animate = true;

  // Sign Out Function
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInPage(),
        ),
      );
    }
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

  // call function
  void _initiateCall(String phoneNumber) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          const phoneNumber = '0761516278';
          _initiateCall(phoneNumber);
        },
        label: const Text('Call Admin'),
        icon: const Icon(Icons.call),
      ),
      appBar: AppBar(
        title: Text(
          'Profile',
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
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            // get user data
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final profilePictureUrl = userData['profilePictureUrl'];

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                // profile picture
                Center(
                  child: AvatarGlow(
                    startDelay: const Duration(milliseconds: 1000),
                    glowColor: Theme.of(context).colorScheme.primary,
                    glowShape: BoxShape.circle,
                    animate: animate,
                    curve: Curves.easeInOut,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: ClipOval(
                        child: profilePictureUrl != null
                            ? Image.network(
                                profilePictureUrl,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                                errorBuilder: (context, error, stackTrace) =>
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
                  ),
                ),
                const SizedBox(height: 32),

                // Name Card
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
                          'Email',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userData['name'],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Email Card
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
                          'Email Address',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentUser.email!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Contact Number Card
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
                          'Phone Number',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userData['contactNumber'],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Edit Profile Button
                FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text('Edit Profile'),
                ),
                const SizedBox(height: 12),

                // Log Out Button
                OutlinedButton.icon(
                  onPressed: alertDialog,
                  icon: const Icon(Icons.logout_outlined),
                  label: const Text('Log Out'),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}





 

/*
Center(
                        child: CircleAvatar(
                          radius: 59,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              image: profilePictureUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(profilePictureUrl),
                                    )
                                  : const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/profile.jpg'),
                                    ),
                            ),
                          ),
                        ),
                      ),
 */