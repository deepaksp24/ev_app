// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: const Color.fromARGB(235, 255, 255, 255),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.circular(100)),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              onTap: () {
                showGoogleAutoComplete(context);
              },
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText: 'Search for a destination',
                hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

void showGoogleAutoComplete(BuildContext context) async {
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
  ).whenComplete(() => print('Autocomplete'));
  if (p != null) {
    print(p.description);
  }
}
