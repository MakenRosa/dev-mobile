import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _cityController = TextEditingController();
  String? _cityName;
  double? _temperature;
  double? _minTemperature;
  double? _maxTemperature;
  String? _description;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _fetchWeatherData(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse('https://weather.contrateumdev.com.br/api/weather/city/?city=$city');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _cityName = data['name'];
          _temperature = data['main']['temp'].toDouble();
          _minTemperature = data['main']['temp_min'].toDouble();
          _maxTemperature = data['main']['temp_max'].toDouble();
          _description = data['weather'][0]['description'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _cityName = null;
          _temperature = null;
          _minTemperature = null;
          _maxTemperature = null;
          _description = null;
          _errorMessage = 'City not found';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _cityName = null;
        _temperature = null;
        _minTemperature = null;
        _maxTemperature = null;
        _description = null;
        _errorMessage = 'An error occurred while fetching weather data';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetValues() {
    setState(() {
      _cityName = null;
      _temperature = null;
      _minTemperature = null;
      _maxTemperature = null;
      _description = null;
      _isLoading = false;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) async {
                await _fetchWeatherData(value);
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Center(
                heightFactor: 1.0,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        _cityName ?? 'Enter a city name',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 194, 194, 194),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Center(
                  heightFactor: 1.0,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          '${_temperature ?? 0}°C',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Min',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            '${_minTemperature ?? 0}°C',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Max',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            '${_maxTemperature ?? 0}°C',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Center(
                heightFactor: 1.0,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        _description ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () async {
                  _resetValues();
                  await _fetchWeatherData(_cityController.text);
                },
                child: const Text('Search'),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}