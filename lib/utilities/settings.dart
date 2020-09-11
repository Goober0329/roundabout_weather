import 'package:flutter/material.dart';

import 'constants.dart';

class Settings {
  String address;
  int numWeatherWidgets;
  int scaleBarValue;
  Units units;
  bool modified = false;
  bool unitsModifiedOnly = false;
  Settings({
    @required this.units,
    @required this.scaleBarValue,
    @required this.numWeatherWidgets,
    this.address,
  });
}
