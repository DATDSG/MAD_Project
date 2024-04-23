import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditHostelsPage extends StatefulWidget {
  final DocumentSnapshot hostelData;

  const EditHostelsPage({
    super.key,
    required this.hostelData,
  });

  @override
  State<EditHostelsPage> createState() => _EditHostelsPageState();
}

class _EditHostelsPageState extends State<EditHostelsPage> {
  List<Uint8List> pickedImages = [];
  String? hostelImageUrl;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isWifiChecked = false;
  bool isLaundryChecked = false;
  bool isFoodChecked = false;
  bool isSecurityChecked = false;
  bool isKitchenChecked = false;
  String? selectedItem = 'Boys';

  List<String> items = ['Boys', 'Girls'];

  @override
  void initState() {
    super.initState();
    isWifiChecked = widget.hostelData['wifi'];
    isLaundryChecked = widget.hostelData['laundry'];
    isFoodChecked = widget.hostelData['food'];
    isSecurityChecked = widget.hostelData['security'];
    isKitchenChecked = widget.hostelData['kitchen'];
    selectedItem = widget.hostelData['accomendation'];
  }

  // update hostel information
  Future updateHostelDetails() async {
    // update hostel name
    nameUpdate();

    // update hostel address
    addressUpdate();

    // update hostel contact number
    contactNumberUpdate();

    // update hostel description
    descriptionUpdate();

    // update hostel price
    priceUpdate();

    // update hostel wifi
    wifiUpdate();

    // update hostel laundry
    laundryUpdate();

    // update hostel food
    foodUpdate();

    // update hostel security
    securityUpdate();

    // update hostel kitchen
    kitchenUpdate();

    // update accomodations
    accomodationUpdate();

    // success alert box
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Hostel details updated successfully'),
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

  // name update
  Future nameUpdate() async {
    if (nameController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'hostelName': nameController.text,
      });
    }
  }

  // address update
  Future addressUpdate() async {
    if (addressController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'address': addressController.text,
      });
    }
  }

  // contact number update
  Future contactNumberUpdate() async {
    if (contactNumberController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'contactNumber': contactNumberController.text,
      });
    }
  }

  // description update
  Future descriptionUpdate() async {
    if (descriptionController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'description': descriptionController.text,
      });
    }
  }

  // price update
  Future priceUpdate() async {
    if (priceController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'price': priceController.text,
      });
    }
  }

  // wifi update
  Future wifiUpdate() async {
    if (isWifiChecked) {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'wifi': isWifiChecked,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'wifi': false,
      });
    }
  }

  // laundry update
  Future laundryUpdate() async {
    if (isLaundryChecked) {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'laundry': isLaundryChecked,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'hostelLaundry': false,
      });
    }
  }

  // food update
  Future foodUpdate() async {
    if (isFoodChecked) {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'food': isFoodChecked,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'food': false,
      });
    }
  }

  // security update
  Future securityUpdate() async {
    if (isSecurityChecked) {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'hostelSecurity': isSecurityChecked,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'security': false,
      });
    }
  }

  // kitchen update
  Future kitchenUpdate() async {
    if (isKitchenChecked) {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'kitchen': isKitchenChecked,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'kitchen': false,
      });
    }
  }

  // accomodation update
  Future accomodationUpdate() async {
    if (selectedItem == 'Boys') {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'accomendation': selectedItem,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Hostels')
          .doc(widget.hostelData.id)
          .update({
        'accomendation': selectedItem,
      });
    }
  }

// update hostel images
  Future updateHostelImages() async {
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

      FirebaseFirestore.instance
          .collection('Hostels')
          .doc(nameController.text)
          .set({
        'hostelImageUrl': imageUrls,
      });
    }
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
              'Edit Hostel',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Hostels')
              .doc(widget.hostelData.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              // get hostel data
              final hostelData = snapshot.data!.data() as Map<String, dynamic>;
              final hostelName = hostelData['hostelName'];
              final contactNumber = hostelData['contactNumber'];
              final price = hostelData['price'];
              final description = hostelData['description'];
              final address = hostelData['address'];

              return ListView(
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
                            color: Colors.black.withOpacity(0.1),
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
                                  decoration: InputDecoration(
                                    hintText: hostelName,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 10),
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
                          const Padding(
                            padding: EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              'Address',
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
                                  decoration: InputDecoration(
                                    hintText: address,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 10),
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
                          const Padding(
                            padding: EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              'Contact Number',
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
                                  decoration: InputDecoration(
                                    hintText: contactNumber,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 10),
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
                          const Padding(
                            padding: EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              'Description',
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
                                  decoration: InputDecoration(
                                    hintText: description,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 10),
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
                          const Padding(
                            padding: EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              'Price',
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
                                  decoration: InputDecoration(
                                    hintText: price,
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 10),
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

                  // facilitites text
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

                  // facility list
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // wifi
                          Checkbox(
                            value: isWifiChecked,
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.green;
                              }
                              return Colors.white;
                            }),
                            onChanged: (value) => setState(() {
                              isWifiChecked = !isWifiChecked;
                            }),
                          ),

                          // wifi text
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
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.green;
                              }
                              return Colors.white;
                            }),
                            onChanged: (value) => setState(() {
                              isLaundryChecked = !isLaundryChecked;
                            }),
                          ),

                          // laundry text
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
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.green;
                              }
                              return Colors.white;
                            }),
                            onChanged: (value) => setState(() {
                              isFoodChecked = !isFoodChecked;
                            }),
                          ),

                          // Food text
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
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.green;
                              }
                              return Colors.white;
                            }),
                            onChanged: (value) => setState(() {
                              isKitchenChecked = !isKitchenChecked;
                            }),
                          ),

                          // kitchen text
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
                            fillColor: MaterialStateColor.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.green;
                              }
                              return Colors.white;
                            }),
                            onChanged: (value) => setState(() {
                              isSecurityChecked = !isSecurityChecked;
                            }),
                          ),

                          // Security text
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

                  // accomodation text
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
                            if (newValue != null) {
                              setState(() {
                                selectedItem = newValue;
                              });
                            }
                          },
                          items: items
                              .map<DropdownMenuItem<String>>((String value) {
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

                  // pictures
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

                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  //         child: Container(
                  //           width: 100,
                  //           height: 100,
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.rectangle,
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: Colors.grey,
                  //           ),
                  //           child: const Center(
                  //             child: Icon(
                  //               Icons.add,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  //         child: Container(
                  //           width: 100,
                  //           height: 100,
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.rectangle,
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: Colors.grey,
                  //           ),
                  //           child: const Center(
                  //             child: Icon(
                  //               Icons.add,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  //         child: Container(
                  //           width: 100,
                  //           height: 100,
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.rectangle,
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: Colors.grey,
                  //           ),
                  //           child: const Center(
                  //             child: Icon(
                  //               Icons.add,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  //         child: Container(
                  //           width: 100,
                  //           height: 100,
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.rectangle,
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: Colors.grey,
                  //           ),
                  //           child: const Center(
                  //             child: Icon(
                  //               Icons.add,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // save button
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: updateHostelDetails,
                        style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all(Colors.grey),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.green[400],
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Save',
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
                          shadowColor: MaterialStateProperty.all(Colors.grey),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
