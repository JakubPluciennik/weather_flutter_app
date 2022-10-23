import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_api_app/models/forecast.dart';
import 'package:weather_api_app/models/location.dart';
import 'package:weather_api_app/models/weather.dart';
import 'package:weather_api_app/extensions.dart';
import 'package:weather_api_app/auth/secrets.dart';

class CurrentWeatherPage extends StatefulWidget {
  final List<Location> locations;
  const CurrentWeatherPage(this.locations);

  @override
  _CurrentWeatherPageState createState() =>
      _CurrentWeatherPageState(this.locations);
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  final List<Location> locations;
  final Location location;
  Weather? _weather;

  _CurrentWeatherPageState(List<Location> locations)
      : this.locations = locations,
        this.location = locations[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: ListView(children: <Widget>[
          currentWeatherViews(this.locations, this.location, this.context),
          forecastViewsHourly(this.location),
          forecastViewsDaily(this.location),
        ]));
  }
}

Widget currentWeatherViews(
    List<Location> locations, Location location, BuildContext context) {
  Weather? _weather;
  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _weather = snapshot.data as Weather;
        if (_weather == null) {
          return Text("Błąd przy odczytywaniu pogody");
        } else {
          return Column(children: [
            //createAppBar(locations, location, context),
            weatherBox(_weather),
            weatherDetailsBox(_weather),
          ]);
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
    future: getCurrentWeather(location),
  );
}

Widget forecastViewsHourly(Location location) {
  Forecast? _forecast;

  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _forecast = snapshot.data as Forecast;
        if (_forecast == null) {
          return Text("Błąd przy odczytywaniu pogody");
        } else {
          return hourlyBoxes(_forecast);
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
    future: getForecast(location),
  );
}

Widget forecastViewsDaily(Location location) {
  Forecast? _forecast;

  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _forecast = snapshot.data as Forecast;
        if (_forecast == null) {
          return Text("Błąd przy odczytywaniu pogody");
        } else {
          return dailyBoxes(_forecast);
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
    future: getForecast(location),
  );
}

Widget weatherBox(Weather? _weather) {
  return Stack(children: [
    Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      height: 160.0,
      decoration: BoxDecoration(
          color: Colors.indigoAccent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 4,
              blurRadius: 10,
            )
          ]),
    ),
    Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      height: 160.0,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getWeatherIcon(_weather!.icon),
            Container(
                margin: const EdgeInsets.all(5),
                child: Text("${_weather.description.capitalizeFirstOfEach}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.white,
                    ))),
            Container(
                margin: const EdgeInsets.all(5),
                child: Text(_weather.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Colors.white,
                    )))
          ],
        )),
        Column(
          children: [
            Container(
                child: Text(
              "${_weather.temp.toInt()}°C",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 60,
                color: Colors.white,
              ),
            )),
            Container(
              child: Text(
                "Odczuwalna: ${_weather.feelsLike.toInt()}°",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ]),
    )
  ]);
}

Widget weatherDetailsBox(Weather? _weather) {
  return Container(
      padding: const EdgeInsets.only(left: 15, top: 25, right: 15, bottom: 25),
      margin: EdgeInsets.only(left: 15, top: 5, bottom: 15, right: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3),
            )
          ]),
      child: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              Container(
                  child: Text("Wiatr",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.grey,
                      ))),
              Container(
                child: Text(
                  "${_weather!.wind} km/h",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          )),
          Expanded(
              child: Column(
            children: [
              Container(
                  child: Text("Wilgotność",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.grey,
                      ))),
              Container(
                child: Text(
                  "${_weather.humidity.toInt()} %",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          )),
          Expanded(
              child: Column(
            children: [
              Container(
                  child: Text("Ciśnienie",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.grey,
                      ))),
              Container(
                child: Text(
                  "${_weather.pressure} hPa",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ))
        ],
      ));
}

Widget hourlyBoxes(Forecast? _forecast) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 0.0),
    height: 150,
    child: ListView.builder(
      padding: const EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 8),
      scrollDirection: Axis.horizontal,
      itemCount: _forecast!.hourly.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            padding:
                const EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  )
                ]),
            child: Column(children: [
              Text("${_forecast.hourly[index].temp.round()}°C",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Colors.black,
                  )),
              getWeatherIcon(_forecast.hourly[index].icon),
              Text("${getTimeFromTimestamp(_forecast.hourly[index].dt)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey,
                  )),
            ]));
      },
    ),
  );
}

Widget dailyBoxes(Forecast? _forecast) {
  return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.only(left: 8, top: 0, bottom: 8, right: 8),
      itemCount: _forecast!.daily.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            padding:
                const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
            margin:
                const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  getDateFromTimestamp(_forecast.daily[index].dt),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                )),
                Expanded(
                    child: getWeatherIconSmall(_forecast.daily[index].icon)),
                Expanded(
                    child: Text(
                  "${_forecast.daily[index].high.toInt()}°/${_forecast.daily[index].low.toInt()}°",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ))
              ],
            ));
      });
}

Future getCurrentWeather(Location location) async {
  Weather weather;
  String city = location.city;
  var url =
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=pl";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    weather = Weather.fromJson(jsonDecode(response.body));
  } else {
    // ERROR HANDLING
    throw Exception("Błąd przy odczytywaniu danych z API");
  }

  return weather;
}

Future getForecast(Location location) async {
  Forecast forecast;
  String lat = location.lat;
  String lon = location.lon;
  var url =
      "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=pl";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    forecast = Forecast.fromJson(jsonDecode(response.body));
  } else {
    // ERROR HANDLING
    throw Exception("Błąd przy odczytywaniu danych z API");
  }

  return forecast;
}

Image getWeatherIcon(String _icon) {
  String path = 'assets/icons/';
  String imageExtension = ".png";
  return Image.asset(
    path + _icon + imageExtension,
    width: 70,
    height: 70,
  );
}

Image getWeatherIconSmall(String _icon) {
  String path = 'assets/icons/';
  String imageExtension = ".png";
  return Image.asset(
    path + _icon + imageExtension,
    width: 40,
    height: 40,
  );
}

String getTimeFromTimestamp(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = new DateFormat('h:mm a');
  return formatter.format(date);
}

String getDateFromTimestamp(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = new DateFormat('E');
  return formatter.format(date);
}
