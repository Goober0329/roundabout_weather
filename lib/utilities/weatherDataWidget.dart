import 'package:flutter/material.dart';
import 'package:round_about_weather/utilities/roundaboutWeather.dart';
import 'dart:math';

import 'constants.dart';

/*
 * Data that I (probably) have
 *
 * 'location'
 * 'type'
 * 'description'
 * 'iconID'
 * 'temperature'
 * 'windSpeed'
 * 'windDegree'
 * 'cityName'
 *
 */

class WeatherDataWidget extends StatelessWidget {
  final Units units;
  final Map data;
  final double size;
  final bool selected;
  final Function(Map) onSelectWidget2Homepage;
  final VoidCallback onSelectWidget2Roundabout;

  WeatherDataWidget(
      {@required this.units,
      @required this.data,
      @required this.size,
      @required this.selected,
      this.onSelectWidget2Homepage,
      this.onSelectWidget2Roundabout});

  @override
  Widget build(BuildContext context) {
    String iconID;
    int windDegree;
    int temperature;
    String temperatureUnits;

    bool invert; // invert the icon image at night.

    // get what you need from the passed data.
    if (data == null) {
      // this code, ideally, should not be reached. I just have to make sure
      // to account for null data when passing in the info to the roundabout
      Map tempData = RoundaboutWeatherData(null, null).centralData;
      iconID = tempData['iconID'];
      windDegree = tempData['windDegree'];
      temperature = tempData['temperature'];
      temperatureUnits = units == Units.imperial ? '°F' : '°C';
      invert = iconID.contains('n');
    } else {
      // need to check if any variable is null or corrupted...?
      iconID = data['iconID'] == null ? nullIcon : data['iconID'];
      windDegree = data['windDegree'] == null ? nullDegree : data['windDegree'];
      temperature =
          data['temperature'] == null ? nullTemp : data['temperature'].round();
      temperatureUnits = units == Units.imperial ? '°F' : '°C';
      invert = iconID.contains('n');
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onSelectWidget2Homepage != null) {
          onSelectWidget2Homepage(data);
        }
        onSelectWidget2Roundabout();
      },
      child: Container(
        width: size,
        height: size,
        child: Stack(
          children: [
            // Icon
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: size * 3 / 4,
                height: size * 3 / 4,
                decoration: BoxDecoration(
                  color: iconIDBackgroundColor[iconID],
                  shape: BoxShape.circle,
                  boxShadow: [containerShadow.scale(selected ? 3 : 1)],
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.75,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(invert
                        ? RGBMatrices['inverse']
                        : RGBMatrices['identity']),
                    child: Image.asset(
                      'images/$iconID.png',
                    ),
                  ),
                ),
              ),
            ),
            // Temperature
            Positioned(
              right: 0,
              bottom: size / 15,
              child: Container(
                width: size * 2 / 4,
                height: size * 2 / 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [containerShadow],
                ),
                child: Center(
                  child: Text(
                    '$temperature$temperatureUnits',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: size / 7.5),
                  ),
                ),
              ),
            ),
            // Wind Direction
            Positioned(
              bottom: size / 30,
              right: size / 2.5,
              child: Container(
                width: size * 1.15 / 4,
                height: size * 1.15 / 4,
                decoration: BoxDecoration(
                  color: Color(0xFFF19E9E),
                  shape: BoxShape.circle,
                  boxShadow: [containerShadow],
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: windDegree * pi / 180 + pi,
                    child: FractionallySizedBox(
                      widthFactor: 0.70,
                      child: Image(
                        image: AssetImage('images/navigation.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
