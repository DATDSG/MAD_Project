import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key, required this.location});

  final ValueChanged<LatLng> location;

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  LatLng? _currentPosition;
  LatLng? _placeLocation;
  double _zoomLevel = 13;

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
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: _zoomLevel,
              ),
              onCameraMove: (CameraPosition cameraPosition) {
                _zoomLevel = cameraPosition.zoom;
              },
              onMapCreated: ((GoogleMapController controller) =>
                  _googleMapController.complete(controller)),
              markers: {
                if (_placeLocation != null)
                  Marker(
                      markerId: const MarkerId("currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _placeLocation!)
              },
              onLongPress: _addMarker,
              gestureRecognizers: Set()
                ..add(
                    Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                ..add(Factory<ScaleGestureRecognizer>(
                    () => ScaleGestureRecognizer()))
                ..add(
                    Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                ..add(Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer()))
                ..add(Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer())),
            ),
    );
  }

  Future<void> _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _currentLocation;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    if (_currentLocation.latitude != null &&
        _currentLocation.longitude != null) {
      setState(() {
        _currentPosition =
            LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
        _cameraToPosition(_currentPosition!);
      });
    }
  }

  Future<void> _cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _googleMapController.future;
    CameraPosition _newCameraPosition =
        CameraPosition(target: position, zoom: _zoomLevel);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  void _addMarker(LatLng pos) {
    setState(() {
      _placeLocation = pos;
      widget.location(pos);
    });
  }
}
