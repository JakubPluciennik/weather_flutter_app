import 'package:flutter/material.dart';
import 'package:weather_api_app/currentWeather.dart';
import 'package:weather_api_app/models/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  List<Location> locations = [
    new Location(
        city: "warsaw", country: "PL", lat: "52.2319581", lon: "21.0067249")
  ];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrentWeatherPage(locations),
    );
  }
}
