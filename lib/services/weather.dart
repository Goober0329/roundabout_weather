import 'locationData.dart';
import 'networking.dart';

import '../utilities/constants.dart';

const String apiKey = '548c503a98f15a5f9e3ef3823ca76842';
const String openWeatherURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Units units;
  WeatherModel(this.units);

  Future<Map> getLocationWeatherData(
      {String address, LocationData location}) async {
    // if nothing is provided, get the current location weather.
    // if  the location is provided, get the weather at that location.
    // if a city name is provided, get the weather at that city.
    String url;
    LocationData loc;
    if (address == null && location == null) {
      loc = LocationData();
      await loc.getFromCurrent();
      url =
          '$openWeatherURL?lat=${loc.latitude}&lon=${loc.longitude}&appid=$apiKey';
    } else if (location != null) {
      loc = location;
      url =
          '$openWeatherURL?lat=${loc.latitude}&lon=${loc.longitude}&appid=$apiKey';
    } else if (address != null) {
      loc = LocationData();
      await loc.getFromAddress(address);
      url =
          '$openWeatherURL?lat=${loc.latitude}&lon=${loc.longitude}&appid=$apiKey';
    }

    // add units key if units are provided (they always will be)
    if (units != null) {
      url = url + '&units=${units == Units.imperial ? 'imperial' : 'metric'}';
    }

    print(url); // TODO remove <<
    // get weather data at location
    try {
      NetworkHelper helper = NetworkHelper(url);
      dynamic data = await helper.getJSON();

      Map dataMap = Map();
      // coordinate location
      try {
        dataMap['location'] = loc;
      } catch (e) {
        dataMap['location'] = null;
      }
      // weather type
      try {
        dataMap['type'] = data['weather'][0]['main'];
      } catch (e) {
        dataMap['type'] = null;
      }
      // weather description
      try {
        dataMap['description'] = data['weather'][0]['description'];
      } catch (e) {
        dataMap['description'] = null;
      }
      // weather ID
      try {
        dataMap['iconID'] = data['weather'][0]['icon'];
      } catch (e) {
        dataMap['iconID'] = null;
      }
      // temperature
      try {
        dataMap['temperature'] = data['main']['temp'].round();
      } catch (e) {
        dataMap['temperature'] = null;
      }
      // wind speed
      try {
        dataMap['windSpeed'] = (data['wind']['speed'] * 10).round() / 10;
      } catch (e) {
        dataMap['windSpeed'] = null;
      }
      // wind degree
      try {
        dataMap['windDegree'] = data['wind']['deg'];
      } catch (e) {
        dataMap['windDegree'] = null;
      }
      return dataMap;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

/*
* Information that I want at each location
*
*   - coord.lat
*   - coord.lon
*   -
*   - weather[0].main   (https://openweathermap.org/weather-conditions)
*   - weather[0].description
*   - weather[0].icon
*   -
*   - main.temp         &units={metric or imperial}
*   -
*   - wind.speed        (Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.)
*   - wind.deg          (Wind direction, degrees (meteorological))
*   -
*   - name              City name
* */
