import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  LatLng? _currentPosition;

  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map View',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        elevation: 0,
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 13,
              ),
              onMapCreated: ((GoogleMapController controller) =>
                  _googleMapController.complete(controller)),
              markers: {
                Marker(
                    markerId: const MarkerId("currentLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _currentPosition!)
              },
            ),
    );
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentPosition!);
        });
      }
    });
  }

  Future<void> _cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _googleMapController.future;
    CameraPosition newCameraPosition =
        CameraPosition(target: position, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }
}
