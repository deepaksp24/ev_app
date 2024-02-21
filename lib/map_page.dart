import 'package:ev_app/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ev_app/map_utils.dart';
import 'package:google_maps_webservice/places.dart';

class MapperClass extends StatefulWidget {
  const MapperClass({Key? key}) : super(key: key);

  @override
  CurrentLocationScreenState createState() => CurrentLocationScreenState();
}

class CurrentLocationScreenState extends State<MapperClass> {
  late GoogleMapController _googleMapController;
  late GoogleMapsPlaces places;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(13.0564640879, 77.5058428128),
    zoom: 7,
  );

  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User current location"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
            },
          ),
          const Positioned(
            top: 30,
            right: 10,
            left: 10,
            child: SearchBarWidget(),
          ),
        ],
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
