import 'dart:math';
import 'package:flutter/foundation.dart';

import 'settings.dart';
import '../utilities/constants.dart';
import '../services/weather.dart';
import '../services/locationData.dart';

class RoundaboutWeather {
  Settings localSettings;

  Map centerWeatherData;
  List<Map> borderWeatherData;

  RoundaboutWeather(this.localSettings);

  Future<RoundaboutWeatherData> getRoundaboutWeatherData() async {
    // need to get the weather data from the central point first and
    // then use the coordinates from that point to get the other points.
    WeatherModel weatherModel = WeatherModel(localSettings.units);
    try {
      centerWeatherData = await weatherModel.getLocationWeatherData(
          address: localSettings.address);
      if (centerWeatherData == null) {
        print('couldn\'t get city weather data');
        centerWeatherData = await weatherModel.getLocationWeatherData();
      }

      // get coordinate locations for the other points
      LocationData center = centerWeatherData['location'];

      List<LocationData> otherLocations = await getRoundaboutCoordinates(
        latitude: center.latitude,
        longitude: center.longitude,
      );

      // get weather data for other points and put in otherWeatherData.
      borderWeatherData = List<Map>();
      for (LocationData location in otherLocations) {
        borderWeatherData
            .add(await weatherModel.getLocationWeatherData(location: location));
      }

      return RoundaboutWeatherData(centerWeatherData, borderWeatherData);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<LocationData>> getRoundaboutCoordinates(
      {@required double latitude, @required double longitude}) async {
    List<LocationData> locations = List<LocationData>();
    double x, y;
    double deltaLatitude, deltaLongitude;
    double a = 2 * pi / localSettings.numWeatherWidgets;
    for (int i = 0; i < localSettings.numWeatherWidgets; i++) {
      x = localSettings.scaleBarValue * cos(a * i + pi / 2);
      y = localSettings.scaleBarValue * sin(a * i + pi / 2);
      if (localSettings.units == Units.imperial) {
        x *= mi2km;
        y *= mi2km;
      }
      deltaLongitude = x * 1000 * globeMeterToDegrees;
      deltaLatitude = y * 1000 * globeMeterToDegrees;
      LocationData toAdd = LocationData();
      await toAdd.getFromCoordinates(
        latitude + deltaLatitude,
        longitude - deltaLongitude,
      );
      locations.add(toAdd);
    }
    return locations;
  }
}

class RoundaboutWeatherData {
  Map centralData;
  List<Map> borderData;
  int numBorder;
  // generate random data if there is no input.
  RoundaboutWeatherData(this.centralData, this.borderData, {this.numBorder}) {
    if (centralData == null && borderData == null) {
      centralData = Map();
      centralData['iconID'] = iconIDBackgroundColor.keys
          .elementAt(Random().nextInt(iconIDBackgroundColor.length));
      centralData['temperature'] = Random().nextInt(50);
      centralData['windDegree'] = Random().nextInt(361);
      borderData = List<Map>(numBorder);
      for (int i = 0; i < numBorder; i++) {
        borderData[i] = Map();
        borderData[i]['iconID'] = iconIDBackgroundColor.keys
            .elementAt(Random().nextInt(iconIDBackgroundColor.length));
        borderData[i]['temperature'] = Random().nextInt(50);
        borderData[i]['windDegree'] = Random().nextInt(361);
      }
    }
  }

  Map getCentralData() {
    return centralData;
  }
}
