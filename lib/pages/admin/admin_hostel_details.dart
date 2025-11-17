import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/admin/edit_hostel.dart';
import 'package:hostel_hive/pages/google_map.dart';

class AdminHostelDetailsPage extends StatefulWidget {
  final DocumentSnapshot hostelData;

  const AdminHostelDetailsPage({
    super.key,
    required this.hostelData,
  });

  @override
  State<AdminHostelDetailsPage> createState() => _AdminHostelDetailsPageState();
}

class _AdminHostelDetailsPageState extends State<AdminHostelDetailsPage> {
  // alert dialog
  void alertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Hostel'),
          content: const Text('Are you sure you want to delete this hostel?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteHostelFunction();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // delete hostel
  Future deleteHostel() async {
    await FirebaseFirestore.instance
        .collection('Hostels')
        .doc(widget.hostelData.id)
        .delete();
  }

  Future deleteHostelFunction() async {
    deleteHostel();

    Navigator.pop(context);

    // delete success alert box
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Successfully!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hostel Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
            // get hostel data
            final hostelData = snapshot.data!.data() as Map<String, dynamic>;
            final price = hostelData['price'];
            final description = hostelData['description'];
            final address = hostelData['address'];
            final wifi = hostelData['wifi'];
            final kitchen = hostelData['kitchen'];
            final security = hostelData['security'];
            final food = hostelData['food'];
            final laundry = hostelData['laundry'];
            final accomendations = hostelData['accomendation'];
            final imageUrls = hostelData['hostelImageUrl'];
            final latitude = hostelData['latitude'];
            final longitude = hostelData['longitude'];

            return ListView(
              children: [
                // Map
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  //child: googleMap(),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child:
                        GoogleMapPage(latitude: latitude, longitude: longitude),
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
                                  color: Colors.black.withValues(alpha: 0.1),
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
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // price & accomendations for
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // accomendations for
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              Flexible(
                                child: Text(
                                  address,
                                  style: const TextStyle(
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

                        // facilities text
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
                            // Facilities
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

                // Edit button
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditHostelsPage(
                              hostelData: widget.hostelData,
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        shadowColor: WidgetStateProperty.all(Colors.grey),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.green[400],
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                // delete button
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: alertDialog,
                      style: ButtonStyle(
                        shadowColor: WidgetStateProperty.all(Colors.grey),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.red[500],
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Delete',
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
            );
          } else {
            return const Center(
              child: Text("Nothing"),
            );
          }
        },
      ),
    );
  }
}
