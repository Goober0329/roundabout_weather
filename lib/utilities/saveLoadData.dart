import 'package:round_about_weather/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';

Future<void> saveData(Settings settings) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('address', settings.address);
  prefs.setInt('numBorder', settings.numWeatherWidgets);
  prefs.setInt('scaleBar', settings.scaleBarValue);
  prefs.setString(
      'units', settings.units == Units.imperial ? 'imperial' : 'metric');
}

Future<Settings> readData() async {
  final prefs = await SharedPreferences.getInstance();

  String unitString = prefs.getString('units') ?? 'imperial';
  Units units = unitString == 'imperial' ? Units.imperial : Units.metric;
  int numBorder = prefs.getInt('numBorder') ?? 5;
  int scaleBarValue = prefs.getInt('scaleBar') ?? 80;
  String address = prefs.getString('address') ?? null;

  Settings toReturn = new Settings(
    units: units,
    numWeatherWidgets: numBorder,
    scaleBarValue: scaleBarValue,
    address: address,
  );
  return toReturn;
}
