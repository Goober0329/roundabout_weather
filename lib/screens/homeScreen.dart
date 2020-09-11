import 'package:flutter/material.dart';
import 'package:round_about_weather/utilities/weatherDataInfoDisplay.dart';

import 'settingsScreen.dart';
import 'loadingScreen.dart';

import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/roundabout.dart';
import '../utilities/roundaboutWeather.dart';

class HomeScreen extends StatefulWidget {
  final Settings settings;
  final RoundaboutWeatherData rawData;
  HomeScreen(this.settings, this.rawData);

  @override
  _HomeScreenState createState() => _HomeScreenState(settings, rawData);
}

class _HomeScreenState extends State<HomeScreen> {
  Settings settings;
  RoundaboutWeatherData rawData;

  _HomeScreenState(this.settings, this.rawData);

  bool settingsIconTap = false;
  bool locationIconTap = false;

  Map selectedWeatherData;

  @override
  void initState() {
    super.initState();
    selectedWeatherData = rawData.centralData;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            // top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: Container()),
                // current location button
                GestureDetector(
                  onTap: _onTapLocation,
                  onTapDown: _onTapDownLocation,
                  onTapUp: _onTapUpLocation,
                  child: Container(
                    width: screenWidth * appBarContainerScale,
                    height: screenWidth * appBarContainerScale,
                    decoration: BoxDecoration(
                      color: locationIconTap
                          ? appBarIconColorTap
                          : appBarIconColor,
                      shape: BoxShape.circle,
                      boxShadow: [containerShadow],
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: screenWidth * appBarIconScale,
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container()),
                // search bar for changing location
                Container(
                  width: screenWidth * searchBarWidthScale,
                  height: screenWidth * searchBarHeightScale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onSubmitted: (value) {
                      _searchOnSubmitted(value);
                    },
                    obscureText: false,
                    textAlign: TextAlign.left,
                    style: searchBarTextStyle,
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      fillColor: searchBarFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search',
                      hintStyle:
                          searchBarTextStyle.copyWith(color: Color(0xFFA1A1A1)),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container()),
                // settings button
                GestureDetector(
                  onTap: _onTapSettings,
                  onTapDown: _onTapDownSettings,
                  onTapUp: _onTapUpSettings,
                  child: Container(
                    width: screenWidth * appBarContainerScale,
                    height: screenWidth * appBarContainerScale,
                    decoration: BoxDecoration(
                      color: settingsIconTap
                          ? appBarIconColorTap
                          : appBarIconColor,
                      shape: BoxShape.circle,
                      boxShadow: [containerShadow],
                    ),
                    child: Icon(
                      Icons.settings,
                      color: Colors.black,
                      size: screenWidth * appBarIconScale,
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),

            Expanded(flex: 2, child: Container()),
            // Roundabout Weather display
            Container(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Roundabout(
                  data: rawData,
                  settings: settings,
                  size: constraints.maxWidth,
                  showTrack: true,
                  onSelectWeatherDataHomepage: (value) {
                    setState(() {
                      selectedWeatherData = value;
                    });
                  },
                );
              }),
            ),

            Expanded(flex: 4, child: Container()),
            // Selected WeatherDataWidget information
            WeatherDataInfoDisplay(
              settings: settings,
              selectedWeatherData: selectedWeatherData,
            ),

            Expanded(flex: 3, child: Container()),
          ],
        ),
      ),
    );
  }

  // gesture detector controllers for location button
  void _onTapLocation() async {
    settings.address = null;
    _updatePageFromSettings();
  }

  void _onTapDownLocation(TapDownDetails _details) {
    setState(() {
      locationIconTap = true;
    });
  }

  void _onTapUpLocation(TapUpDetails _details) {
    setState(() {
      locationIconTap = false;
    });
  }

  // gesture detector controllers for settings button
  void _onTapSettings() async {
    settings = await _updateSettings(context);
    if (settings.modified && settings.unitsModifiedOnly) {
      setState(() {
        // change the units of everything.
        // by calling set state the units automatically
        // will update based on the new settings
      });
    } else if (settings.modified) {
      _updatePageFromSettings();
    }
  }

  void _onTapDownSettings(TapDownDetails _details) {
    setState(() {
      settingsIconTap = true;
    });
  }

  void _onTapUpSettings(TapUpDetails _details) {
    setState(() {
      settingsIconTap = false;
    });
  }

  // typed in the search bar
  void _searchOnSubmitted(String value) {
    if (value == null || value.length == 0) {
      return;
    } else {
      settings.address = value;
      _updatePageFromSettings();
    }
  }

  // changes route to settings screen and gets new settings
  Future<Settings> _updateSettings(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(settings),
      ),
    );
  }

  // changes route to loading screen and fetches new data.
  void _updatePageFromSettings({String address}) {
    // take the new settings and load the new data.
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          settings: settings,
          address: address,
        ),
      ),
    );
  }
}
