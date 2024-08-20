import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weather_app/current_weather.dart';
import 'package:weather_app/model.dart';
import 'package:weather_app/weather_api_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.red),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherApiClient client = WeatherApiClient();
  Future<Weather?>? _weatherFuture;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weatherFuture = _fetchWeather("Depok");
  }

  Future<Weather?> _fetchWeather(String city) async {
    try {
      return await client.getCurrentWeather(city);
    } on IOException {
      showSnackBar("No internet connection");
      return null;
    } on TimeoutException {
      showSnackBar("Internet connection is slow or timed out");
      return null;
    } catch (e) {
      showSnackBar("An error occurred: ${e.toString()}");
      return null;
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _updateWeather() {
    setState(() {
      _weatherFuture = _fetchWeather(_cityController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Weather?>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            final weather = snapshot.data;
            return weather != null
                ? currentWeather(
                    icon: weather.getWeatherIcon().icon!,
                    temp: " ${weather.temp?.toStringAsFixed(0) ?? 'N/A'}°",
                    date: weather.getFormattedDate(),
                    location: weather.cityName ?? 'Unknown',
                    iconColor: weather.getWeatherIcon().color!,
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 54),
                        SizedBox(height: 10),
                        Text(
                          "No weather data available",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
          } else {
            return const Center(
              child: Text(
                "No weather data available",
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}
