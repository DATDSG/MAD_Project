import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ManageHostelsPage extends StatefulWidget {
  const ManageHostelsPage({super.key});

  @override
  State<ManageHostelsPage> createState() => _ManageHostelsPageState();
}

class _ManageHostelsPageState extends State<ManageHostelsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // add hostel button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[400],
        onPressed: () {},
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
        child: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        image: const DecorationImage(
                          image: AssetImage('assets/images/img1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // hostel name
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        const Text(
                          'Hostel Name',
                          style: TextStyle(
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
                            left: 0.1,
                          ),
                          itemBuilder: (context, _) => Transform.scale(
                            scale: 0.8,
                            child: const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          ignoreGestures: true,
                          onRatingUpdate: (rating) => () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}