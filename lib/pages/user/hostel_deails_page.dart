import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/google_map.dart';

class HostelDetailsPage extends StatefulWidget {
  final DocumentSnapshot hostelData;

  const HostelDetailsPage({
    super.key,
    required this.hostelData,
  });

  @override
  State<HostelDetailsPage> createState() => _HostelDetailsPageState();
}

class _HostelDetailsPageState extends State<HostelDetailsPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Call Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green[400],
        child: const Icon(
          Icons.phone,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        elevation: 2,
        shadowColor: Colors.black,
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Hostels')
              .doc(widget.hostelData.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data() as Map<String, dynamic>;

              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    data['hostelName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            } else {
              return const Text('');
            }
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Hostels')
            .doc(widget.hostelData.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // get hostel data
            final hostelData = snapshot.data!.data() as Map<String, dynamic>;
            final price = hostelData['price'];
            final description = hostelData['description'];
            final accomendations = hostelData['accomendation'];
            final imageUrls = hostelData['hostelImageUrl'];
            final wifi = hostelData['wifi'];
            final kitchen = hostelData['kitchen'];
            final security = hostelData['security'];
            final food = hostelData['food'];
            final laundry = hostelData['laundry'];

            return ListView(
              children: [
                // Map
                const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  //child: googleMap(),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: googleMap(),
                  ),
                ),

                // Hostel Images
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: List.generate(
                        imageUrls.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Container(
                            width: 250,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(imageUrls[index]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Hostel Details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 10,
                      top: 10,
                      bottom: 10,
                    ),
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
                        // price & accomendations
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // accomenation for
                            Text(
                              accomendations,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),

                            // price
                            Text(
                              '$price/Month',
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),

                        // location
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined),
                              Flexible(
                                child: Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // hostel description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        Text(
                          description,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                        
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            'Facilities',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // facilitis
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (wifi)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.wifi),
                                        SizedBox(width: 5),
                                        Text(
                                          'Wifi',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (kitchen)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.kitchen),
                                        SizedBox(width: 5),
                                        Text(
                                          'Kitchen',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (security)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.security),
                                        SizedBox(width: 5),
                                        Text(
                                          'Security',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (food)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.fastfood),
                                        SizedBox(width: 5),
                                        Text(
                                          'Food',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (laundry)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.local_laundry_service),
                                        SizedBox(width: 5),
                                        Text(
                                          'Laundry',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
