import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage(
      {super.key, required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  LatLng? _initialPosition;
  LatLng? _currentPosition;

  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  Location location = Location();

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _initialPosition = LatLng(widget.latitude, widget.longitude);
    _currentPosition = _initialPosition;
    _getLocation().then((value) => {
          getPolylinePoints()
              .then((coordinates) => {generatePolylineFromPoints(coordinates)})
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: _initialPosition!,
          zoom: 15,
        ),
        onMapCreated: ((GoogleMapController controller) =>
            _googleMapController.complete(controller)),
        markers: {
          Marker(
              markerId: const MarkerId("Location"),
              icon: BitmapDescriptor.defaultMarker,
              position: _initialPosition!),
          Marker(
              markerId: const MarkerId("currentLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: _currentPosition!)
        },
        polylines: Set<Polyline>.of(polylines.values),
        gestureRecognizers: Set()
          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
          ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
          ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
          ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
          ..add(Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () => _cameraToPosition(_initialPosition!),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  Future<void> _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

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
    CameraPosition _newCameraPosition =
        CameraPosition(target: position, zoom: 15);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDfeF-zPKoh1Jiz4ErNct2-OAm7miPEXas",
        PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        PointLatLng(_initialPosition!.latitude, _initialPosition!.longitude));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      debugPrint(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
