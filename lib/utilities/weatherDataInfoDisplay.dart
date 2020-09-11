import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';

import 'constants.dart';
import 'settings.dart';
import '../services/locationData.dart';

class WeatherDataInfoDisplay extends StatelessWidget {
  final Settings settings;
  final Map selectedWeatherData;
  WeatherDataInfoDisplay({this.settings, this.selectedWeatherData});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 7 / 8,
      child: Column(
        children: [
          // City Name
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            LocationData loc = selectedWeatherData['location'];
            String name = loc.name;
            bool fade = false;
            if (name == null || name == ', ') {
              name = 'Unknown Location';
              fade = true;
            }
            if (name[0] == ',') {
              name = name.substring(2);
            }
            return Container(
              height: screenWidth * 1.25 / 8,
              width: screenWidth * 0.8,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth / 15,
                vertical: screenWidth / 45,
              ),
              decoration: BoxDecoration(
                color: fade ? Colors.white.withOpacity(0.3) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [(fade ? containerShadowFade : containerShadow)],
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.w400,
                    color: fade ? Colors.black.withOpacity(0.4) : Colors.black,
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 20),
          // weather description
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: screenWidth / 35),
              // weather icon
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                String iconID = selectedWeatherData['iconID'];
                bool invert = iconID.contains('n');
                return Container(
                  width: screenWidth / 10,
                  height: screenWidth / 10,
                  decoration: BoxDecoration(
                    color: iconIDBackgroundColor[iconID],
                    shape: BoxShape.circle,
                    boxShadow: [containerShadow],
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
                );
              }),
              SizedBox(width: screenWidth / 35),
              // temperature
              Container(
                width: screenWidth / 4.8,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  String temperatureUnits =
                      settings.units == Units.imperial ? '°F' : '°C';
                  return Text(
                    '${selectedWeatherData['temperature']} $temperatureUnits',
                    style: TextStyle(fontSize: 20),
                  );
                }),
              ),
              Container(
                width: screenWidth / 20,
              ),
              // weather description
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                String text = selectedWeatherData['description'];
                text = text[0].toUpperCase() + text.substring(1);
                return Container(
                  width: screenWidth / 2.3,
                  child: AutoSizeText(
                    '$text',
                    style: TextStyle(fontSize: 20),
                    maxLines: 2,
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 10),
          // wind description
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: screenWidth / 35),
              // wind degree icon
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                String iconID = selectedWeatherData['iconID'];
                return Container(
                  width: screenWidth / 10,
                  height: screenWidth / 10,
                  decoration: BoxDecoration(
                    color: Color(0xFFF19E9E),
                    shape: BoxShape.circle,
                    boxShadow: [containerShadow],
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: selectedWeatherData['windDegree'] * pi / 180 + pi,
                      child: FractionallySizedBox(
                        widthFactor: 0.70,
                        child: Image(
                          image: AssetImage('images/navigation.png'),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(width: screenWidth / 35),
              // direction
              Container(
                width: screenWidth / 4.8,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  int degree = selectedWeatherData['windDegree'];
                  String cardinal = cardinalFromWindDegree(degree);
                  return Text(
                    '$cardinal wind',
                    style: TextStyle(fontSize: 20),
                  );
                }),
              ),
              Container(
                width: screenWidth / 20,
              ),
              // wind speed
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                String text = selectedWeatherData['windSpeed'].toString();
                String speedUnits =
                    settings.units == Units.imperial ? 'mph' : 'kph';
                return Container(
                  width: screenWidth / 2.3,
                  child: AutoSizeText(
                    '$text $speedUnits',
                    style: TextStyle(fontSize: 20),
                    maxLines: 1,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
