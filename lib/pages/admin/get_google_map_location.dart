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
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
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
              gestureRecognizers: {
                Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
                Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer()),
                Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer()),
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
        CameraPosition(target: position, zoom: _zoomLevel);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  void _addMarker(LatLng pos) {
    setState(() {
      _placeLocation = pos;
      widget.location(pos);
    });
  }
}
