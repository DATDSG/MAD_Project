import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hostel_hive/pages/admin/get_google_map_location.dart';
import 'package:image_picker/image_picker.dart';

class AddHostelPage extends StatefulWidget {
  const AddHostelPage({super.key});

  @override
  State<AddHostelPage> createState() => _AddHostelPageState();
}

class _AddHostelPageState extends State<AddHostelPage> {
  List<Uint8List> pickedImages = [];
  String? hostelImageUrl;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final userCollection = FirebaseFirestore.instance.collection('Hostels');
  final user = FirebaseAuth.instance.currentUser!;

  bool isWifiChecked = false;
  bool isLaundryChecked = false;
  bool isFoodChecked = false;
  bool isSecurityChecked = false;
  bool isKitchenChecked = false;
  String? selectedItem = 'Boys';
  double? latitude;
  double? longitude;

  List<String> items = ['Boys', 'Girls'];

  // add hostels to database
  Future addHostel() async {
    // add list of hostel images to database
    final List<String> imageUrls = [];

    for (final image in pickedImages) {
      final String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('hostel_images/$imageName');
      final UploadTask uploadTask = storageRef.putData(image);
      await uploadTask.whenComplete(() => null);
      final String imageUrl = await storageRef.getDownloadURL();

      imageUrls.add(imageUrl);
    }

    FirebaseFirestore.instance
        .collection('Hostels')
        .doc(nameController.text)
        .set({
      'userId': user.uid,
      'hostelName': nameController.text,
      'address': addressController.text,
      'contactNumber': contactNumberController.text,
      'description': descriptionController.text,
      'price': priceController.text,
      'wifi': isWifiChecked,
      'laundry': isLaundryChecked,
      'food': isFoodChecked,
      'security': isSecurityChecked,
      'kitchen': isKitchenChecked,
      'accomendation': selectedItem,
      'hostelImageUrl': imageUrls,
      'latitude': latitude,
      'longitude': longitude,
    });

    // success message
    message();

    // clear text fields
    setState(() {
      nameController.clear();
      addressController.clear();
      contactNumberController.clear();
      descriptionController.clear();
      priceController.clear();
      isWifiChecked = false;
      isLaundryChecked = false;
      isFoodChecked = false;
      isSecurityChecked = false;
      isKitchenChecked = false;
      pickedImages.clear();
    });
  }

  // success message
  void message() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Hostel added Successfully!'),
          actions: <Widget>[
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

  // image upload
  Future<void> uploadHostelImages() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return;

    final Uint8List imageData = File(image.path).readAsBytesSync();
    setState(() {
      pickedImages.add(imageData);
    });
  }

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
            Text(
              'Add Hostel',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: ListView(
          children: [
            // hostel name
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(5, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "Hostel Name",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 10,
                      ),
                      child: SizedBox(
                        height: 25,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 15),
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // address
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 10,
                      ),
                      child: SizedBox(
                        height: 25,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextField(
                            controller: addressController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 15),
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // contact number
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "Contact Number",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 10,
                      ),
                      child: SizedBox(
                        height: 25,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextField(
                            controller: contactNumberController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 15),
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // description
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 10,
                      ),
                      child: SizedBox(
                        height: 25,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 15),
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // price
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "Price",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 10,
                      ),
                      child: SizedBox(
                        height: 25,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextField(
                            controller: priceController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 15),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // facilitites Text
            const Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                top: 20,
              ),
              child: Text(
                'Facilities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Facilities
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // wifi
                    Checkbox(
                      value: isWifiChecked,
                      fillColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.green;
                        }
                        return Colors.white;
                      }),
                      onChanged: (value) => setState(() {
                        isWifiChecked = !isWifiChecked;
                      }),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15,
                        right: 32,
                      ),
                      child: Text(
                        'Wifi',
                      ),
                    ),

                    // Laundry
                    Checkbox(
                      value: isLaundryChecked,
                      fillColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.green;
                        }
                        return Colors.white;
                      }),
                      onChanged: (value) => setState(() {
                        isLaundryChecked = !isLaundryChecked;
                      }),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15,
                        right: 20,
                      ),
                      child: Text(
                        'Laundry',
                      ),
                    ),

                    // Foods
                    Checkbox(
                      value: isFoodChecked,
                      fillColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.green;
                        }
                        return Colors.white;
                      }),
                      onChanged: (value) => setState(() {
                        isFoodChecked = !isFoodChecked;
                      }),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15,
                        right: 10,
                      ),
                      child: Text(
                        'Foods',
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kitchen
                    Checkbox(
                      value: isKitchenChecked,
                      fillColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.green;
                        }
                        return Colors.white;
                      }),
                      onChanged: (value) => setState(() {
                        isKitchenChecked = !isKitchenChecked;
                      }),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15,
                        right: 10,
                      ),
                      child: Text(
                        'Kitchen',
                      ),
                    ),

                    // Security
                    Checkbox(
                      value: isSecurityChecked,
                      fillColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.green;
                        }
                        return Colors.white;
                      }),
                      onChanged: (value) => setState(() {
                        isSecurityChecked = !isSecurityChecked;
                      }),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 15,
                        right: 10,
                      ),
                      child: Text(
                        'Security',
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
              ),
              child: Row(
                children: [
                  const Text(
                    'Accomodation',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  // dropdown
                  DropdownButton<String>(
                    value: selectedItem,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedItem = newValue;
                      });
                    },
                    items: items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    elevation: 10,
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                top: 20,
                bottom: 10,
              ),
              child: Text(
                'Pictures',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // pictures
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pickedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == pickedImages.length) {
                    return GestureDetector(
                      onTap: uploadHostelImages,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.all(5),
                    width: 100,
                    child: Image.memory(
                      pickedImages[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                top: 20,
                bottom: 10,
              ),
              child: Text(
                'Location',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
              ),
              child: GoogleMapPage(
                location: (pos) {
                  latitude = pos.latitude;
                  longitude = pos.longitude;
                },
              ),
            ),

            // add button
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addHostel,
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
                    'Add Hostel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // cancel button
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shadowColor: WidgetStateProperty.all(Colors.grey),
                    backgroundColor: WidgetStateProperty.all(
                      Colors.white,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 102, 187, 106),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
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
        ),
      ),
    );
  }
}
