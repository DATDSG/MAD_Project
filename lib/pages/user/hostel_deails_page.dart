import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/google_map.dart';
import 'package:url_launcher/url_launcher.dart';

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
  // get current user
  final currentUser = FirebaseAuth.instance.currentUser!;

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
          final phoneNumber = widget.hostelData['contactNumber'];
          _initiateCall(phoneNumber);
        },
        label: const Text('Call Hostel'),
        icon: const Icon(Icons.phone),
      ),
      appBar: AppBar(
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Hostels')
              .doc(widget.hostelData.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              return Text(
                data['hostelName'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              );
            }
            return const Text('Loading...');
          },
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Hostels')
            .doc(widget.hostelData.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final hostelData = snapshot.data!.data() as Map<String, dynamic>;
            final price = hostelData['price'];
            final description = hostelData['description'];
            final address = hostelData['address'];
            final accomendations = hostelData['accomendation'];
            final imageUrls = hostelData['hostelImageUrl'];
            final wifi = hostelData['wifi'];
            final kitchen = hostelData['kitchen'];
            final security = hostelData['security'];
            final food = hostelData['food'];
            final laundry = hostelData['laundry'];
            final latitude = hostelData['latitude'];
            final longitude = hostelData['longitude'];

            return ListView(
              children: [
                // Map
                SizedBox(
                  width: double.infinity,
                  height: 220,
                  child:
                      GoogleMapPage(latitude: latitude, longitude: longitude),
                ),

                const SizedBox(height: 16),

                // Hostel Images Carousel
                SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: List.generate(
                        imageUrls.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 250,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Main Info Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price and Type
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    accomendations,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Type of Accommodation',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rs. $price',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                  Text(
                                    'per month',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Divider(height: 24),

                          // Address
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      address,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Text(
                            'About',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Facilities
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Facilities',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildFacilityTile(
                            context,
                            'WiFi',
                            Icons.wifi,
                            wifi,
                          ),
                          _buildFacilityTile(
                            context,
                            'Kitchen',
                            Icons.kitchen,
                            kitchen,
                          ),
                          _buildFacilityTile(
                            context,
                            'Security',
                            Icons.security,
                            security,
                          ),
                          _buildFacilityTile(
                            context,
                            'Food',
                            Icons.restaurant,
                            food,
                          ),
                          _buildFacilityTile(
                            context,
                            'Laundry',
                            Icons.local_laundry_service,
                            laundry,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildFacilityTile(
    BuildContext context,
    String name,
    IconData icon,
    bool available,
  ) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: available
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            available ? 'Available' : 'Not Available',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: available
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
