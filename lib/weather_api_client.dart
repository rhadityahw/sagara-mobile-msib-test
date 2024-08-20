import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model.dart';

class WeatherApiClient {
  final String _apiKey = "b590e8f174c52e18a7ffa01cfa4fe88f";

  Future<Weather>? getCurrentWeather(String? location) async {
    try {
      var endpoint = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$_apiKey&units=metric");

      var response = await http.get(endpoint);

      if (response.statusCode != 200) {
        var body = jsonDecode(response.body);
        throw "Error ${response.statusCode}: ${body['message']}";
      }

      var body = jsonDecode(response.body);
      return Weather.fromJson(body);
    } catch (e) {
      rethrow;
    }
  }
}
