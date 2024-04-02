import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  Widget _buildNoHostelsWidget() {
    return const Center(
      child: Text(
        'No Hostels Available!',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // circular progress indicator
  Widget _buildGradientCircularProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 4.0,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        backgroundColor: Colors.transparent,
        value: null, // This makes it indeterminate
        semanticsValue: 'Loading...',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 2,
        shadowColor: Colors.black,
        title: const Text(
          'Find Place',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
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
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Filter hostels based on search query
                        _filterHostels(_searchController.text);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Hostels')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildGradientCircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildNoHostelsWidget();
                  }

                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> hostels = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: hostels.length,
                      itemBuilder: (context, index) {
                        final hostelData =
                            hostels[index].data() as Map<String, dynamic>;
                        final hostelName = hostelData['hostelName'];

                        // hostel tile
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Container(
                              width: double.infinity,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
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
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/img1.jpg'),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          RatingBar.builder(
                                            initialRating: 3,
                                            minRating: 1,
                                            maxRating: 3,
                                            direction: Axis.horizontal,
                                            itemCount: 5,
                                            itemPadding: const EdgeInsets.only(
                                                left: 0.1),
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
                                          ),
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
                    return _buildNoHostelsWidget();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Google Map
//googleMap(),
// Container(
//   width: double.infinity,
//   height: 180,
//   decoration: BoxDecoration(
//     image: const DecorationImage(
//       image: AssetImage(
//         'assets/images/map.png',
//       ),
//       fit: BoxFit.cover,
//     ),
//     color: Colors.white,
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.1),
//         spreadRadius: 2,
//         blurRadius: 1,
//         offset: const Offset(0, 1),
//       ),
//     ],
//   ),
//   child: const SizedBox(
//     width: double.infinity,
//     height: 180,
//     child: googleMap(),
//   ),
// ),

