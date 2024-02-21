import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    //print("Location services are disabled");
    return Future.error('Location services are disabled');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      //print("Location permission denied");
      return Future.error("Location permission denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    //print("Location permissions are permanently denied");
    return Future.error('Location permissions are permanently denied');
  }

  Position position = await Geolocator.getCurrentPosition();

  return position;
}
