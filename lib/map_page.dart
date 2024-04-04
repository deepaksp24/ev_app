// ignore_for_file: avoid_print

import 'dart:async';
import 'package:ev_app/search_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ev_app/map_utils.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geo_coding;
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:developer' as devtools show log;

typedef ToolkitLatLng = mp.LatLng;

String recipientToken =
    'dj7W4KMvTI-NmlWJlyj_zv:APA91bEC6Mer6-OhwYcCh4vVbhGqxeVcznqOtTc3PsWbkjuoCiKeqpvyyi__MW1vnZwrFJ__q3zAucZc7inetLD1vni9T6auOnZJjr9HBnKoovuEbcybWKdJ5rTzPn2NK4gD6gak1p9_';
String title = 'your-title';
String body = 'your-body';

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
  final Set<Polyline> _polylines = {};
  final DatabaseReference trafficSignalsRef = FirebaseDatabase.instance.ref();
  //final String googleAPIKey = 'AIzaSyCstj5OMwmGOYOYifN4I_A-tz_qtP7iL5c';
  final String googleAPIKey = 'AIzaSyC6X6AnRB84WfuwrSYLvivBjtHCfUq1lls';
  bool polylinesVisible = false;
  bool trackingUserLocation = false;
  late List<mp.LatLng> predefinedLocations = [
    mp.LatLng(13.0565, 77.5057),
    mp.LatLng(34.5678, 90.1234),
    mp.LatLng(13.0476, 77.5013),
  ];
  List<mp.LatLng> locationsOnPath = [];
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
            polylines: _polylines,
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
                  _moveCameraToBounds(position);
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              // _checkLocationOnPath();
              //_trackUserLocation();
              bool result = await sendPushMessage(
                recipientToken: recipientToken,
                title: title,
                body: body,
              );
              print("messagae sent  $result");
            },
            tooltip: 'Start Navigation',
            child: const Icon(
              Icons.message_outlined,
              size: 30,
            ),
          ),
          if (polylinesVisible)
            FloatingActionButton(
              onPressed: () async {
                // _checkLocationOnPath();
                _trackUserLocation();
                // bool result = await sendPushMessage(
                //   recipientToken: recipientToken,
                //   title: title,
                //   body: body,
                // );
                //print(result);
              },
              tooltip: 'Start Navigation',
              child: const Icon(
                Icons.assistant_direction_outlined,
                size: 50,
              ),
            ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            onPressed: () async {
              Position position = await determinePosition();
              _moveCameraToUserLocation(position);
              _addMarkerToUserLocation(position);
              setState(() {});
            },
            label: const Text("Current Location"),
            icon: const Icon(Icons.my_location_sharp),
          ),
        ],
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

  Future<void> _moveCameraToBounds(Position position) async {
    Position userLocation = await determinePosition();
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

  void _addMarkerToUserLocation(Position position) {
    _markers.clear();
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

  Future<void> _addMarkerToSelectedLocation(Position position) async {
    //List<LatLng> polylineCoordinates = [];
    //_markers.clear();
    _markers.add(Marker(
        markerId: const MarkerId('selectedLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: "Destination")));

    Position curposition = await determinePosition();

    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(curposition.latitude, curposition.longitude),
        PointLatLng(position.latitude, position.longitude));
    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: const PolylineId('selectedLocationPolyline'),
        color: Colors.blue,
        width: 5,
        points: polylineCoordinates,
      ));
      locationsOnPath.clear();
      _checkLocationOnPath(polylineCoordinates);
    }

    setState(() {
      polylinesVisible = true;
    });
  }

  Future<String?> showGoogleAutoComplete(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
      offset: 0,
      radius: 100000000,
      strictbounds: false,
      language: "en",
      context: context,
      mode: Mode.overlay,
      apiKey: googleAPIKey,
      components: [Component(Component.country, "in")],
      types: [],
      hint: "Search Hospitals",
    );

    return p?.description;
  }

  void _trackUserLocation() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );
      for (var predefinedLocation in locationsOnPath) {
        num distance = mp.SphericalUtil.computeDistanceBetween(
          mp.LatLng(position.latitude, position.longitude),
          predefinedLocation,
        );

        if (distance <= 30) {
          print('User is within the radius of the predefined location.');
          // Perform any necessary actions here
        }
      }

      // Update user's marker position
      setState(() {
        _markers
            .removeWhere((marker) => marker.markerId.value == 'userLocation');
        _markers.add(
          Marker(
            markerId: const MarkerId('userLocation'),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: "User's Location"),
          ),
        );
        _moveCameraToUserLocation(position);
      });
      _updateUserLocationToFirebase(position);
      //_checkLocationOnPath();
    });
  }

  // Future<void> _checkLocationOnPath(List<LatLng> polylineCoordinates) async {
  //   //LatLng userLatLng = LatLng(predefinedLocations, position.longitude);
  //   List<mp.LatLng> mpPolylineCoordinates = polylineCoordinates
  //       .map((coord) => mp.LatLng(coord.latitude, coord.longitude))
  //       .toList();
  //   double radius =
  //       20; // Set the radius (in meters) within which you want to check

  //   for (mp.LatLng predefinedLocation in predefinedLocations) {
  //     // Convert predefined location to ToolkitLatLng

  //     bool isLocationOnPath = mp.PolygonUtil.isLocationOnPath(
  //         mp.LatLng(predefinedLocation.latitude, predefinedLocation.longitude),
  //         mpPolylineCoordinates,
  //         false,
  //         tolerance: radius);

  //     if (isLocationOnPath) {
  //       // User is within the radius of the predefined location along the polyline
  //       print('location present in polyline.');
  //       locationsOnPath.add(predefinedLocation);
  //       // Perform any necessary actions here
  //     } else {
  //       // User is not within the radius of the predefined location along the polyline
  //       print('location not in polyline.');
  //     }
  //   }
  //   print('locations on path $locationsOnPath');
  // }

  Future<void> _checkLocationOnPath(List<LatLng> polylineCoordinates) async {
    trafficSignalsRef.child('Traffic_signals').once().then((event) {
      final List<dynamic>? data = event.snapshot.value as List<dynamic>?;
      if (data == null) {
        print('Data is null or invalid');
        return;
      }
      for (var value in data) {
        double lat = value['lat'] as double;
        double lon = value['lon'] as double;
        mp.LatLng location = mp.LatLng(lat, lon);

        List<mp.LatLng> mpPolylineCoordinates = polylineCoordinates
            .map((coord) => mp.LatLng(coord.latitude, coord.longitude))
            .toList();
        double radius =
            5; // Set the radius (in meters) within which you want to check
        //print(mpPolylineCoordinates);
        bool isLocationOnPath = mp.PolygonUtil.isLocationOnPath(
          mp.LatLng(location.latitude, location.longitude),
          mpPolylineCoordinates,
          false,
          tolerance: radius,
        );

        if (isLocationOnPath) {
          //print('Location $location is on the path.');
          locationsOnPath.add(location);
          // Perform any necessary actions here
        } else {
          //print('Location $location is not on the path.');
        }
      }
      print('locationsOnPath $locationsOnPath');
    });
  }

  //   trafficSignalsRef.once().then((event) {
  //     if (event.snapshot.value is Map) {
  //       Map<dynamic, dynamic>? signalsData =
  //           event.snapshot.value as Map<dynamic, dynamic>?;

  //       if (signalsData == null) {
  //         print('Data is null or invalid');
  //         return;
  //       }

  //       signalsData.forEach((key, value) {
  //         double lat = value['lat'] as double;
  //         double lon = value['lon'] as double;
  //         LatLng location = LatLng(lat, lon);
  //         // Now you can check if this location is on the polyline or not
  //         bool isLocationOnPath =
  //             _isLocationOnPath(location, polylineCoordinates);

  //         if (isLocationOnPath) {
  //           print('Location $location is on the path.');
  //           // Perform any necessary actions here
  //         } else {
  //           print('Location $location is not on the path.');
  //         }
  //       });
  //     } else {
  //       print('Data received from Firebase is not in the expected format');
  //     }
  //   });
  // }

  void _updateUserLocationToFirebase(Position position) {
    DatabaseReference userLocationRef =
        FirebaseDatabase.instance.ref().child('user_locations');

    userLocationRef.set({
      'latitude': position.latitude,
      'logitude': position.longitude,
      'timestamp': ServerValue.timestamp,
    });
  }

  Future<bool> sendPushMessage({
    required String recipientToken,
    required String title,
    required String body,
  }) async {
    final jsonCredentials =
        await rootBundle.loadString('data/new-project-afe89-982de6fad46d.json');
    final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

    final client = await auth.clientViaServiceAccount(
      creds,
      ['https://www.googleapis.com/auth/cloud-platform'],
    );

    final notificationData = {
      'message': {
        'token': recipientToken,
        'notification': {'title': title, 'body': body},
        "data": {"custom_key": "is this really working"},
      },
    };

    const String senderId = '434991368322';
    final response = await client.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      return true; // Success!
    }

    devtools.log(
        'Notification Sending Error Response status: ${response.statusCode}');
    devtools.log('Notification Response body: ${response.body}');
    return false;
  }
}

// [Lat: 13.0567702, Lng: 77.5073114, Lat: 13.0666836, Lng: 77.5032893, Lat: 13.0566292, Lng: 77.5073597, Lat: 13.0566128, Lng: 77.5072593, Lat: 13.0567509, Lng: 77.5072292, Lat: 13.0666816, Lng: 77.5033502]