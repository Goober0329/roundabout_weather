import 'package:flutter/material.dart';

import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/roundabout.dart';
import '../utilities/roundaboutWeather.dart';
import '../utilities/saveLoadData.dart';

class SettingsScreen extends StatefulWidget {
  final Settings settings;
  SettingsScreen(this.settings);

  @override
  _SettingsScreenState createState() => _SettingsScreenState(settings);
}

class _SettingsScreenState extends State<SettingsScreen> {
  Settings settings;
  _SettingsScreenState(this.settings);

  // Slider Constants - Unit Difference
  final double distanceMinImperial = 10;
  final double distanceMaxImperial = 200;
  final int distanceDivImperial = 19;

  final double distanceMinMetric = 20;
  final double distanceMaxMetric = 320;
  final int distanceDivMetric = 15;

  bool unitButtonTouch = false;

  RoundaboutWeatherData rawData;

  @override
  void initState() {
    super.initState();
    settings.modified = false;

    rawData =
        RoundaboutWeatherData(null, null, numBorder: maxBorderWeatherData);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        leading: GestureDetector(
          onTap: () async {
            await saveData(settings);
            Navigator.pop(context, settings);
          },
          child: Icon(
            Icons.arrow_back,
            size: screenWidth * appBarIconScale,
          ),
        ),
        title: Text('Settings',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            )),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 2, child: Container()),
            Roundabout(
              data: rawData,
              settings: settings,
              showTrack: true,
              onSelectWeatherDataHomepage: null,
              size: MediaQuery.of(context).size.width,
            ),
            Expanded(flex: 4, child: Container()),
            Text('Roundabout Distance', style: settingsSliderTextStyle),
            SliderTheme(
              data: sliderThemeData,
              child: Slider(
                value: settings.scaleBarValue.toDouble(),
                onChanged: (newValue) {
                  settings.modified = true;
                  settings.unitsModifiedOnly = false;
                  setState(() {
                    settings.scaleBarValue = newValue.round();
                  });
                },
                min: (settings.units == Units.imperial
                    ? distanceMinImperial
                    : distanceMinMetric),
                max: (settings.units == Units.imperial
                    ? distanceMaxImperial
                    : distanceMaxMetric),
                divisions: (settings.units == Units.imperial
                    ? distanceDivImperial
                    : distanceDivMetric),
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Text('Roundabout Data Points', style: settingsSliderTextStyle),
            SliderTheme(
              data: sliderThemeData,
              child: Slider(
                value: settings.numWeatherWidgets.toDouble(),
                onChanged: (newValue) {
                  settings.modified = true;
                  settings.unitsModifiedOnly = false;
                  setState(() {
                    settings.numWeatherWidgets = newValue.round();
                  });
                },
                min: minBorderWeatherData.toDouble(),
                max: maxBorderWeatherData.toDouble(),
                divisions: 3,
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            GestureDetector(
              onTap: _onTapUnits,
              onTapDown: _onTapDownUnits,
              onTapUp: _onTapUpUnits,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: unitButtonTouch ? appBarIconColorTap : appBarIconColor,
                  shape: BoxShape.rectangle,
                  boxShadow: [containerShadow],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  String units =
                      settings.units == Units.imperial ? 'Imperial' : 'Metric';
                  return Text(
                    'Units [$units]',
                    style: settingsSliderTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  // gesture detector controllers for settings button
  void _onTapUnits() async {
    if (settings.modified == false) {
      settings.unitsModifiedOnly = true;
    }
    settings.modified = true;
    setState(() {
      if (settings.units == Units.imperial) {
        settings.units = Units.metric;
        settings.scaleBarValue = miToKm(settings.scaleBarValue);
      } else {
        settings.units = Units.imperial;
        settings.scaleBarValue = kmToMi(settings.scaleBarValue);
      }
    });
  }

  void _onTapDownUnits(TapDownDetails _details) {
    setState(() {
      unitButtonTouch = true;
    });
  }

  void _onTapUpUnits(TapUpDetails _details) {
    setState(() {
      unitButtonTouch = false;
    });
  }

  int miToKm(int value) {
    int converted = (value.toDouble() * mi2km).toInt();
    int step =
        ((distanceMaxMetric - distanceMinMetric) / distanceDivMetric).round();
    return round(converted, step);
  }

  int kmToMi(int value) {
    int converted = (value.toDouble() * km2mi).toInt();
    int step =
        ((distanceMaxImperial - distanceMinImperial) / distanceDivImperial)
            .round()
            .toInt();
    return round(converted, step);
  }

  int round(int num, int multiple) {
    int temp = num % multiple;
    if (temp < (multiple / 2).ceil())
      return num - temp;
    else
      return num + multiple - temp;
  }
}
