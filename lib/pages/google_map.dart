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
  bool _cameraTarget = false;
  double _zoomLevel = 15;

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
          zoom: _zoomLevel,
        ),
        onCameraMove: (CameraPosition cameraPosition) {
          _zoomLevel = cameraPosition.zoom;
        },
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
        gestureRecognizers: {
          Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
          Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
          Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
          Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()),
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape:
            const CircleBorder(side: BorderSide(width: 2, color: Colors.green)),
        onPressed: () => {
          _cameraTarget = !_cameraTarget,
          _cameraToPosition(_initialPosition!),
        },
        child: const Icon(Icons.location_pin),
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

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDfeF-zPKoh1Jiz4ErNct2-OAm7miPEXas",
        PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        PointLatLng(_initialPosition!.latitude, _initialPosition!.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
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
