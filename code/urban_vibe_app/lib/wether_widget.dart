import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String weather = 'Loading...';
  String temperature = '';
  LocationData? currentLocation;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation?.latitude;
      final lon = currentLocation?.longitude;
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (lat != null && lon != null) {
        final url =
            'https://api.brightsky.dev/weather?lat=$lat&lon=$lon&date=$date';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            weather = data['weather'][0]['condition'];
            temperature = '${data['weather'][0]['temperature']}°C';
          });
        } else {
          setState(() {
            weather = 'Failed to load weather';
          });
        }
      } else {
        setState(() {
          weather = 'Location not available';
        });
      }
    } catch (e) {
      setState(() {
        weather = 'Error fetching weather';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.wb_sunny, size: 40, color: Colors.orange),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weather,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  temperature,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
