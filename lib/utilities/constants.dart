import 'package:flutter/material.dart';

/*    Units and Conversions    */

enum Units {
  metric,
  imperial,
}

const double mi2km = 1.60934;
const double km2mi = 0.62137;

const double globeDegreeToMeters = 111139;
const double globeMeterToDegrees = 1 / globeDegreeToMeters;

double fahrenheitToCelsius(double f) {
  return (f - 32) * 5 / 9;
}

double celsiusToFahrenheit(double c) {
  return (c * 9 / 5) + 32;
}

String cardinalFromWindDegree(int degree) {
  String cardinalDegree = '';

  degree += 180;
  degree = degree % 360;

  List<String> cardinalDirections = [
    'S',
    'SW',
    'W',
    'NW',
    'N',
    'NE',
    'E',
    'SE'
  ];
  int index = 0;
  double off = 45 / 2;
  for (int i = 0; i < 360; i += 45) {
    if (i == 0) {
      if (degree > 360 - off || degree < off) {
        cardinalDegree = cardinalDirections[index];
        break;
      }
    } else {
      if (degree > i - off && degree < i + off) {
        cardinalDegree = cardinalDirections[index];
        break;
      }
    }
    index++;
  }
  return cardinalDegree;
}

/*    Display and Visuals    */

const scaffoldBackgroundColor = Color(0xFFEBEBEB);

const double appBarIconScale = 1 / 11.5;
const double appBarContainerScale = 1 / 9.5;
const Color appBarIconColor = Colors.white;
const Color appBarIconColorTap = Colors.white70;
const Color appBarBackgroundColor = Color(0xFF4CA0EC);

const double searchBarWidthScale = 0.65;
const double searchBarHeightScale = searchBarWidthScale * 0.15;
const double searchBarTextSize = 20;
const Color searchBarFillColor = Color(0xFFD4D4D4);
TextStyle searchBarTextStyle = TextStyle(
  color: Colors.black,
  fontSize: searchBarTextSize,
);

Color sliderActiveColor = Color(0xFF4CA0EC);
Color sliderInactiveColor = Color(0xFFBBCEDE);
const double settingsSliderTextSize = 23;
TextStyle settingsSliderTextStyle = TextStyle(
  color: Colors.black,
  fontSize: settingsSliderTextSize,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);
SliderThemeData sliderThemeData = SliderThemeData(
  activeTrackColor: sliderActiveColor,
  inactiveTrackColor: sliderInactiveColor,
  activeTickMarkColor: sliderActiveColor,
  inactiveTickMarkColor: sliderInactiveColor,
  trackHeight: 6.0,
  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13.0, elevation: 6.0),
);

BoxShadow containerShadow = BoxShadow(
  color: Colors.grey[700],
  blurRadius: 3.0,
  spreadRadius: 0,
  offset: Offset(3.0, 3.0),
);

BoxShadow containerShadowFade = BoxShadow(
  color: Colors.grey[700].withOpacity(0.2),
  blurRadius: 3.0,
  spreadRadius: 0,
  offset: Offset(3.0, 3.0),
);

const int minBorderWeatherData = 3;
const int maxBorderWeatherData = 6;
const String nullIcon = 'badData';
const int nullDegree = 45;
const int nullTemp = 404;
TextStyle nullIconTextStyle = TextStyle(
  color: Colors.black,
  fontSize: settingsSliderTextSize,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w500,
);

const Map iconIDBackgroundColor = {
  '01d': Color(0xFFFCF18E),
  '02d': Color(0xFF9BCEF5),
  '03d': Color(0xFF999998),
  '04d': Color(0xFF7A7A7A),
  '09d': Color(0xFF6DB7F0),
  '10d': Color(0xFF4CA0EC),
  '11d': Color(0xFF397CBD),
  '13d': Color(0xFFCCE8FA),
  '50d': Color(0xFFC1C1C2),
  '01n': Color(0xFF030C11),
  '02n': Color(0xFF193D5E),
  '03n': Color(0xFF3F4140),
  '04n': Color(0xFF262626),
  '09n': Color(0xFF142F46),
  '10n': Color(0xFF0E2335),
  '11n': Color(0xFF0F2336),
  '13n': Color(0xFF275884),
  '50n': Color(0xFF595959),
};

const Map<String, List<double>> RGBMatrices = {
  'identity': [
//  R  G  B  A  Const
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0, //
  ],
  'inverse': [
//  R  G  B  A  Const
    -1, 0, 0, 0, 255, //
    0, -1, 0, 0, 255, //
    0, 0, -1, 0, 255, //
    0, 0, 0, 1, 0, //
  ],
};
