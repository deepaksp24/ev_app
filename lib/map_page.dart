import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ev_app/map_utils.dart';

class MapperClass extends StatefulWidget {
  const MapperClass({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<MapperClass> {
  late GoogleMapController _googleMapController;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(13.0564640879, 77.5058428128),
    zoom: 7,
  );

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User current location"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        markers: _markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await determinePosition();

          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14,
            ),
          ));

          _markers.clear();

          _markers.add(Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
          ));

          setState(() {});
        },
        label: const Text("Current Location"),
        icon: const Icon(Icons.my_location_sharp),
      ),
    );
  }
}
