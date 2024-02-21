import 'package:ev_app/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ev_app/map_utils.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geo_coding;

class MapperClass extends StatefulWidget {
  const MapperClass({Key? key}) : super(key: key);

  @override
  CurrentLocationScreenState createState() => CurrentLocationScreenState();
}

//String searchText = '';

class CurrentLocationScreenState extends State<MapperClass> {
  late GoogleMapController _googleMapController;
  late GoogleMapsPlaces places;
  final TextEditingController _destination = TextEditingController();

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
              _onMapCreated(controller);
            },
          ),
          Positioned(
            top: 30,
            right: 10,
            left: 10,
            child: SearchBarWidget(
              destination: _destination,
              onTap: () async {
                String? searchposition = await showGoogleAutoComplete(context);

                if (searchposition != null) {
                  _destination.text = searchposition;
                  List<geo_coding.Location> placemarks =
                      await geo_coding.locationFromAddress(searchposition);
                  Position position = Position(
                    latitude: placemarks[0].latitude,
                    longitude: placemarks[0].longitude,
                    accuracy: 100.0,
                    altitude: 0.0,
                    heading: 0.0,
                    speed: 0.0,
                    speedAccuracy: 0.0,
                    timestamp: DateTime.now(),
                    altitudeAccuracy: 0.0,
                    headingAccuracy: 0.0,
                  );
                  _moveCameraToUserLocation(position);
                  _addMarkerToSelectedLocation(position);

                  setState(() {
                    //searchText = searchposition;
                  });
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await determinePosition();
          _moveCameraToUserLocation(position);
          _addMarkerToUserLocation(position);
          setState(() {});
        },
        label: const Text("Current Location"),
        icon: const Icon(Icons.my_location_sharp),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  void _moveCameraToUserLocation(Position position) {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      ),
    ));
  }

  void _addMarkerToUserLocation(Position position) {
    _markers.clear();
    _markers.add(Marker(
      markerId: const MarkerId('currentLocation'),
      position: LatLng(position.latitude, position.longitude),
    ));
  }

  void _addMarkerToSelectedLocation(Position position) {
    _markers.clear();
    _markers.add(Marker(
      markerId: const MarkerId('selectedLocation'),
      position: LatLng(position.latitude, position.longitude),
    ));
  }
}

Future<String?> showGoogleAutoComplete(BuildContext context) async {
  const kGoogleApiKey = 'AIzaSyCstj5OMwmGOYOYifN4I_A-tz_qtP7iL5c';

  Prediction? p = await PlacesAutocomplete.show(
    offset: 0,
    radius: 100000000,
    strictbounds: false,
    language: "en",
    context: context,
    mode: Mode.overlay,
    apiKey: kGoogleApiKey,
    components: [Component(Component.country, "in")],
    types: [],
    hint: "Search Hospitals",
  );

  return p?.description;
}
