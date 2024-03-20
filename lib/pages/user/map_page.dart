import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostel_hive/pages/google_map.dart';
import 'package:hostel_hive/pages/user/hostel_deails_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                'Find Place',
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
        child: ListView(
          children: [
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
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          decoration: InputDecoration(
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
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // Google Map
            //googleMap(),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/map.png',
                  ),
                  fit: BoxFit.cover,
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            for (int i = 0; i < 5; i++)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HostelDetailsPage(),
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        // Ratings
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
