import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum WeatherStatus { clouds, clear, rain }

class Weather {
  String? cityName;
  double? temp;
  DateTime? date;
  WeatherStatus? weatherStatus;

  Weather({this.cityName, this.temp, this.date, this.weatherStatus});

  Weather.fromJson(Map<String, dynamic> json) {
    cityName = json["name"];
    temp = json["main"]["temp"];
    date = DateTime.fromMillisecondsSinceEpoch(json["dt"] * 1000);
    weatherStatus = _parseWeatherStatus(json["weather"][0]["main"]);
  }

  WeatherStatus? _parseWeatherStatus(String? status) {
    switch (status) {
      case 'Clouds':
        return WeatherStatus.clouds;
      case 'Clear':
        return WeatherStatus.clear;
      case 'Rain':
        return WeatherStatus.rain;
      default:
        return null;
    }
  }

  String getFormattedDate() {
    return DateFormat.yMMMMd('en_US').format(date ?? DateTime.now());
  }

  Icon getWeatherIcon() {
    IconData iconData;
    Color color;

    switch (weatherStatus) {
      case WeatherStatus.clouds:
        iconData = Icons.cloud;
        color = Colors.grey;
        break;
      case WeatherStatus.clear:
        iconData = Icons.wb_sunny;
        color = Colors.yellow;
        break;
      case WeatherStatus.rain:
        iconData = Icons.beach_access;
        color = Colors.blue;
        break;
      default:
        iconData = Icons.help;
        color = Colors.black;
    }

    return Icon(iconData, color: color, size: 64);
  }
}
