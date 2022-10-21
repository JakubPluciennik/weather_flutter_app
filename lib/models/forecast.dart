import 'dart:math';

import 'package:weather_api_app/models/hourly.dart';
import 'package:weather_api_app/models/daily.dart';

class Forecast {
  final List<Hourly> hourly;
  final List<Daily> daily;

  Forecast({required this.hourly, required this.daily});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    List<dynamic> hourlyData = json['hourly'];
    List<dynamic> dailyData = json['daily'];

    List<Hourly> hourly = [];
    List<Daily> daily = [];

    hourlyData.forEach((element) {
      var hour = Hourly.fromJson(element);
      hourly.add(hour);
    });
    dailyData.forEach((element) {
      var day = Daily.fromJson(element);
      daily.add(day);
    });

    return Forecast(hourly: hourly, daily: daily);
  }
}
