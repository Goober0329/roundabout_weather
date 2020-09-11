import 'package:flutter/material.dart';
import 'dart:math';

import '../utilities/roundaboutWeather.dart';
import '../utilities/weatherDataWidget.dart';
import '../utilities/constants.dart';
import 'settings.dart';

class Roundabout extends StatefulWidget {
  final Settings settings;
  final RoundaboutWeatherData data;
  final double size;
  final bool showTrack;
  final Function(Map) onSelectWeatherDataHomepage;

  Roundabout({
    @required this.settings,
    @required this.data,
    @required this.size,
    @required this.onSelectWeatherDataHomepage,
    this.showTrack = false,
  });

  @override
  _RoundaboutState createState() => _RoundaboutState(
        settings: settings,
        data: data,
        size: size,
        onSelectWeatherDataHomepage: onSelectWeatherDataHomepage,
        showTrack: showTrack,
      );
}

class _RoundaboutState extends State<Roundabout> {
  final Settings settings;
  final RoundaboutWeatherData data;
  final double size;
  final bool showTrack;

  final double _borderScale = 0.7;
  final double _weatherDataWidgetScale = 1 / 4;
  final double _weatherDataScaleUp = 1.1;
  final double _borderWeatherDataWidgetScale = 0.9;

  // these are the variables that can be changed.
  Function(Map) onSelectWeatherDataHomepage;
  int selectedWeatherData = -1;

  _RoundaboutState({
    @required this.settings,
    @required this.data,
    @required this.size,
    @required this.onSelectWeatherDataHomepage,
    this.showTrack = true,
  });

  @override
  Widget build(BuildContext context) {
    double widgetOffset = _weatherDataWidgetScale / 4;

    return Center(
      child: Column(
        children: [
          // actual roundabout weather
          Container(
            width: size,
            height: size,
            child: Stack(
              children: [
                // border
                Center(
                  child: Container(
                    width: size * _borderScale,
                    height: size * _borderScale,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2.0),
                    ),
                  ),
                ),
                //    the center weather data widget
                Container(
                  alignment: Alignment(widgetOffset, widgetOffset),
                  child: WeatherDataWidget(
                    units: settings.units,
                    data: data == null ? null : data.centralData,
                    size: size *
                        _weatherDataWidgetScale *
                        (selectedWeatherData == -1 ? _weatherDataScaleUp : 1),
                    selected: selectedWeatherData == -1,
                    onSelectWidget2Homepage: onSelectWeatherDataHomepage,
                    onSelectWidget2Roundabout: () {
                      setState(() {
                        selectedWeatherData = -1;
                      });
                    },
                  ),
                ),
                //    the border children
                ..._borderWeatherDataWidgets(size),
              ],
            ),
          ),
          // scale bar
          Container(
            child: Stack(
              children: [
                // scale and horizontal bar
                Container(
                  alignment: Alignment(0.5, 1),
                  child: Column(
                    children: [
                      Text(
                        '${settings.scaleBarValue} ${settings.units == Units.imperial ? 'mi' : 'km'}',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400),
                      ),
                      Container(
                        width: size * _borderScale / 2,
                        height: 3,
                        decoration: BoxDecoration(
                          color: sliderInactiveColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Container> _borderWeatherDataWidgets(double size) {
    List<Container> toReturn = List<Container>();
    double widgetSize = size * _weatherDataWidgetScale;
    double widgetOffset = _weatherDataWidgetScale / 4;
    double x, y;
    double a = 2 * pi / settings.numWeatherWidgets;
    for (int i = 0; i < settings.numWeatherWidgets; i++) {
      x = _borderWeatherDataWidgetScale * cos(a * i - pi / 2);
      y = _borderWeatherDataWidgetScale * sin(a * i - pi / 2);
      x += widgetOffset; // this offset is for center the widgets on the icon
      y += widgetOffset;
      toReturn.add(
        Container(
          alignment: Alignment(x, y),
          child: WeatherDataWidget(
            size: widgetSize *
                (selectedWeatherData == i ? _weatherDataScaleUp : 1),
            data: data == null ? null : data.borderData[i],
            units: settings.units,
            selected: selectedWeatherData == i,
            onSelectWidget2Homepage: onSelectWeatherDataHomepage,
            onSelectWidget2Roundabout: () {
              setState(() {
                selectedWeatherData = i;
              });
            },
          ),
        ),
      );
    }
    return toReturn;
  }
}
