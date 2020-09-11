import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationData {
  double latitude, longitude;
  String name;
  LocationData({this.latitude, this.longitude, this.name});

  Future<void> getFromCurrent() async {
    try {
      Position currentLocation =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation.latitude,
        currentLocation.longitude,
      );

      Placemark placemark = placemarks[0];
      latitude = currentLocation.latitude;
      longitude = currentLocation.longitude;
      name = placemark.locality + ', ' + placemark.administrativeArea;
    } catch (e) {
      print(e);
      latitude = 0;
      longitude = 0;
      name = null;
    }
  }

  Future<void> getFromAddress(String inputAddress) async {
    try {
      List<Location> locations = await locationFromAddress(inputAddress);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        locations[0].latitude,
        locations[0].longitude,
      );

      latitude = locations[0].latitude;
      longitude = locations[0].longitude;
      name = placemarks[0].locality + ', ' + placemarks[0].administrativeArea;
    } catch (e) {
      print(e);
      latitude = 0;
      longitude = 0;
      name = null;
    }
  }

  Future<void> getFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      this.latitude = latitude;
      this.longitude = longitude;
      name = placemarks[0].locality + ', ' + placemarks[0].administrativeArea;

      if (placemarks[0].locality == null ||
          placemarks[0].locality.length == 0) {
        name = null;
      }
      if (placemarks[0].administrativeArea == null ||
          placemarks[0].administrativeArea.length == 0) {
        name = null;
      }
    } catch (e) {
      print(e);
      this.latitude = latitude;
      this.longitude = longitude;
      this.name = null;
    }
  }

  @override
  String toString() {
    return '($name: $latitude, $longitude)';
  }
}
