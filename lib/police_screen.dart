// ignore_for_file: avoid_print
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PoliceScreenClass extends StatefulWidget {
  const PoliceScreenClass({super.key});

  @override
  State<PoliceScreenClass> createState() => _PoliceScreenClassState();
}

class _PoliceScreenClassState extends State<PoliceScreenClass> {
  late GoogleMapController _googleMapController;
  final _databaseref = FirebaseDatabase.instance.ref();
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(13.0279, 12.57), zoom: 14);
  final String googleAPIKey = 'AIzaSyCstj5OMwmGOYOYifN4I_A-tz_qtP7iL5c';
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  @override
  // void initState() {
  //   super.initState();
  //   _determinePosition();
  //   _activateListeners();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Police screen"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 203, 99, 30)),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: _markers,
        polylines: _polylines,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();
          _activateListeners();
          _addpolyline(position);
          _addMarkerToUserLocation(position);
          setState(() {});
        },
        label: const Text("Current Location"),
        icon: const Icon(Icons.my_location_sharp),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      print("Location services are disabled");
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print("Location permission denied");
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied");
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    _addMarkerToUserLocation(position);
    return position;
  }

  // void _activateListeners() {
  //   _databaseref.child('user_locations').onValue.listen((event) {
  //     final Map<String, dynamic> data =
  //         (event.snapshot.value as Map<Object?, Object?>?)!
  //             .cast<String, dynamic>();
  //     final double latitute = data['latitude'] as double;
  //     final double longitutde = data['longitude'] as double;
  //     print(latitute);
  //     print(longitutde);
  //   });
  // }

  Future<void> _activateListeners() async {
    _databaseref.child('user_locations').onValue.listen((event) {
      final Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) {
        print('Data is null or invalid');
        return;
      }

      final double? latitude = data['latitude'] as double?;
      final double? longitude = data['logitude'] as double?;

      if (latitude == null || longitude == null) {
        print('Latitude or longitude is null');
        return;
      }

      // _markers.add(Marker(
      //   markerId: const MarkerId('fetchedLocation'),
      //   position: LatLng(latitude, longitude),
      //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      // ));

      setState(() {
        _markers.removeWhere(
            (marker) => marker.markerId.value == 'fetchedLocation');
        _markers.add(
          Marker(
            markerId: const MarkerId('fetchedLocation'),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: "User's Location"),
          ),
        );
      });
      Position position = Position(
        latitude: latitude,
        longitude: longitude,
        accuracy: 100.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        timestamp: DateTime.now(),
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
      _moveCameraToBounds(position);
      _addpolyline(position);
      print('Latitude: $latitude');
      print('Longitude: $longitude');
    }, onError: (error) {
      print('Error fetching data: $error');
    });
  }

  Future<void> _moveCameraToBounds(Position position) async {
    Position userLocation = await _determinePosition();
    LatLng source = LatLng(userLocation.latitude, userLocation.longitude);
    LatLng destination = LatLng(position.latitude, position.longitude);

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }
    _googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 25),
    );
  }

  Future<void> _addMarkerToUserLocation(Position position) async {
    //_markers.clear();
    _markers.add(
      Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
          infoWindow: const InfoWindow(title: "Source")),
    );
  }

  Future<void> _addpolyline(Position position) async {
    Position curposition = await _determinePosition();

    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(curposition.latitude, curposition.longitude),
        PointLatLng(position.latitude, position.longitude));
    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      //_polylines.clear();
      _polylines.add(Polyline(
        polylineId: const PolylineId('selectedLocationPolyline'),
        color: Colors.blue,
        width: 5,
        points: polylineCoordinates,
      ));
    }

    setState(() {});
  }
}
