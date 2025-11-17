import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/user/hostel_deails_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _searchController = TextEditingController();

  List<DocumentSnapshot> _filteredHostels = [];

  void _filterHostels(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredHostels.clear();
      });
      return;
    }

    final List<DocumentSnapshot> filteredHostels = [];

    for (final hostel in _filteredHostels) {
      final hostelData = hostel.data() as Map<String, dynamic>;
      final hostelName = hostelData['hostelName'];

      if (hostelName.toLowerCase().contains(query.toLowerCase())) {
        filteredHostels.add(hostel);
      }
    }

    setState(() {
      _filteredHostels = filteredHostels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find Place',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search hostels',
              leading: const Icon(Icons.search),
              onChanged: (value) {
                _filterHostels(value);
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Hostels').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No Hostels Available!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }

                if (snapshot.hasData) {
                  final List<DocumentSnapshot> hostels = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              builder: (context) => HostelDetailsPage(
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hostelName ?? 'Unknown',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            hostelData['address'] ?? 'N/A',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                      'No Hostels Available!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
