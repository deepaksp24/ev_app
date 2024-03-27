// ignore_for_file: avoid_print
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PoliceScreenClass extends StatefulWidget {
  const PoliceScreenClass({super.key});

  @override
  State<PoliceScreenClass> createState() => _PoliceScreenClassState();
}

class _PoliceScreenClassState extends State<PoliceScreenClass> {
  late GoogleMapController googleMapController;
  final _databaseref = FirebaseDatabase.instance.ref();
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(13.0279, 12.57), zoom: 14);

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

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
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();

          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14)));

          //markers.clear();

          _markers.add(Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(position.latitude, position.longitude)));

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

    Position position = await Geolocator.getCurrentPosition();

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

  void _activateListeners() {
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

      _markers.add(Marker(
        markerId: const MarkerId('fetchedLocation'),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));

      setState(() {});

      print('Latitude: $latitude');
      print('Longitude: $longitude');
    }, onError: (error) {
      print('Error fetching data: $error');
    });
  }
}
