import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  // Variables to store the basic needs for fetching the url from the API
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

// This function uses the base_url and your personal API key to fetch the data, in simple terms it is used to make a connection to the weather API using your APIkey
  Future<Weather> getWeather(String cityName) async {
  final response = await http.get(
    Uri.parse('$baseUrl?q=paris&APPID=$apiKey&units=metric'),
  );
  
  print('API Response: ${response.body}'); // Debugging line

  if (response.statusCode == 200) {
    return Weather.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load weather data: ${response.body}');
  }
}


// This function is used to get  the required permissions for accessing location from the user as well as Fetch the data fromt he API.
  Future<String> getCurrentCity() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permission denied.');
      return "";
    }
  }

  Position position = await Geolocator.getCurrentPosition(
    locationSettings: AndroidSettings(accuracy: LocationAccuracy.high),
  );

  print('Position: ${position.latitude}, ${position.longitude}');

  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  print('Placemark: $placemarks');

  String? city = placemarks[0].locality;
  return city ?? "";
}
}