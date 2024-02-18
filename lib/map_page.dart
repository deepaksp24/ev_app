import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapperClass extends StatelessWidget {
  const MapperClass({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('map'),
              backgroundColor: const Color.fromARGB(255, 112, 111, 111),
            ),
            body: const Padding(
                padding: EdgeInsets.only(top: 30),
                child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        zoom: 15,
                        target:
                            LatLng(52.52309894124325, 13.413122125924026))))));
  }
}
