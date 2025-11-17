import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/admin/add_hostel.dart';
import 'package:hostel_hive/pages/admin/admin_hostel_details.dart';

class ManageHostelsPage extends StatefulWidget {
  const ManageHostelsPage({super.key});

  @override
  State<ManageHostelsPage> createState() => _ManageHostelsPageState();
}

class _ManageHostelsPageState extends State<ManageHostelsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHostelPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Hostel'),
      ),
      appBar: AppBar(
        title: Text(
          'Manage Hostels',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
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
            return Center(
              child: Text(
                'Add New Hostels',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          if (snapshot.hasData) {
            final List<DocumentSnapshot> hostels = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: hostels.length,
              itemBuilder: (context, index) {
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
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.network(
                            imageUrls[0],
                            width: 130,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 130,
                              height: 140,
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                              child: const Icon(Icons.image),
                            ),
                          ),
                        ),

                        // Hostel Info
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hostelName ?? 'Unknown',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.business,
                                      size: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Tap to manage',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Arrow
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'Add new Hostel',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
        },
      ),
    );
  }
}
