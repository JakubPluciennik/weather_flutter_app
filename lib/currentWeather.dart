import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_api_app/models/weather.dart';

class CurrentWeatherPage extends StatefulWidget {
  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot != null) {
            Weather? _weather = snapshot.data as Weather?;
            if (_weather == null) {
              return Text("Błąd we wczytywaniu pogody");
            } else {
              return weatherBox(_weather);
            }
          } else {
            return CircularProgressIndicator();
          }
        },
        future: getCurrentWeather(),
      )),
    );
  }
}

Widget weatherBox(Weather _weather) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        margin: const EdgeInsets.all(10),
        child: Text(
          "${_weather.temp}°C",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55),
        ),
      ),
      Container(
          margin: const EdgeInsets.all(5), child: Text(_weather.description)),
      Container(
          margin: const EdgeInsets.all(5),
          child: Text("Feels: ${_weather.feelsLike}°C")),
      Container(
          margin: const EdgeInsets.all(5),
          child: Text("H: ${_weather.high}°C L: ${_weather.temp}°C"))
    ],
  );
}

Future getCurrentWeather() async {
  Weather weather;
  String city = "warsaw";
  String apiKey = "45bf8c55c52f7d2df2e488cdfeeef4ca";
  var url =
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    weather = Weather.fromJson(jsonDecode(response.body));
  } else {
    // ERROR HANDLING
    throw Exception("Błąd przy odczytywaniu danych z API");
  }

  return weather;
}
