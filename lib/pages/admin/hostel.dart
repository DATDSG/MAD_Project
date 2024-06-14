import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostel_hive/pages/admin/add_hostel.dart';
import 'package:hostel_hive/pages/admin/admin_hostel_details.dart';

class ManageHostelsPage extends StatefulWidget {
  const ManageHostelsPage({super.key});

  @override
  State<ManageHostelsPage> createState() => _ManageHostelsPageState();
}

class _ManageHostelsPageState extends State<ManageHostelsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  Widget _buildNoHostelsWidget() {
    return const Center(
      child: Text(
        'Add New Hostels',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // add hostel button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[400],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHostelPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 2,
        shadowColor: Colors.black,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                'Manage Hostels',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Hostels')
              .where('userId', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildNoHostelsWidget();
            }

            if (snapshot.hasData) {
              // get the all hostels from database an add hostels to the list
              final List<DocumentSnapshot> hostels = snapshot.data!.docs;

              return ListView.builder(
                itemCount: hostels.length,
                itemBuilder: (context, index) {
                  // get hostel name
                  final hostelData =
                      hostels[index].data() as Map<String, dynamic>;
                  final hostelName = hostelData['hostelName'];
                  final imageUrls = hostelData['hostelImageUrl'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AdminHostelDetailsPage(
                            hostelData: hostels[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Image
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: 130,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrls[0]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            // Hostel name and Rating
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Hostel Name
                                    Text(
                                      hostelName ?? '',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // Rating bar
                                    /*RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      maxRating: 3,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemPadding:
                                          const EdgeInsets.only(left: 0.1),
                                      itemBuilder: (context, _) =>
                                          Transform.scale(
                                        scale: 0.8,
                                        child: const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      ignoreGestures: true,
                                      onRatingUpdate: (rating) {},
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Add new Hostel'),
              );
            }
          },
        ),
      ),
    );
  }
}
