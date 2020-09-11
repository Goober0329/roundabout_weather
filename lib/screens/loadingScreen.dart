import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../screens/homeScreen.dart';
import '../utilities/roundaboutWeather.dart';
import '../utilities/settings.dart';
import '../utilities/saveLoadData.dart';

class LoadingScreen extends StatefulWidget {
  final Settings settings;
  final String address;
  LoadingScreen({this.settings, this.address});

  @override
  _LoadingScreenState createState() =>
      _LoadingScreenState(settings: settings, address: address);
}

class _LoadingScreenState extends State<LoadingScreen> {
  Settings settings;
  String address;
  _LoadingScreenState({this.settings, this.address});

  @override
  void initState() {
    super.initState();
    _getRoundaboutWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4CA0EC),
      body: SpinKitThreeBounce(
        color: Color(0xFF9ED5FA),
        size: 75,
        duration: Duration(milliseconds: 2000),
      ),
    );
  }

  void _getRoundaboutWeatherData() async {
    if (settings == null) {
      settings = await readData();
    }
    RoundaboutWeather roundaboutWeather = RoundaboutWeather(settings);
    RoundaboutWeatherData rawData =
        await roundaboutWeather.getRoundaboutWeatherData();

    if (rawData == null) {
      print('data is null...');
      // TODO need to have some sort of case handler here...
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(settings, rawData),
        ));
  }
}
