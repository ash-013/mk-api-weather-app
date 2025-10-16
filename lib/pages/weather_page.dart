import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mk_api_weather_app/models/weather_model.dart';
import 'package:mk_api_weather_app/service/weather_service.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  // api key
  final _weatherService = WeatherService(
    apiKey: '368c8392cc7fdf198509f7a5b9be8f7f',
  );
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  // fetch weather
  dynamic _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print('Error: ${e.toString()}');
    }
  }

  String getWeatherAnimation(String? condition) {
    switch (condition!.toLowerCase()) {
      case 'clouds':
        return 'assets/cloudy.json';
      case 'mist':
        return 'assets/cloudy.json';
      case 'rain':
        return 'assets/cloudy.json';
      case 'drizzle':
        return 'assets/cloudy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'snow':
        return 'assets/sunny.json';
      case 'haze':
        return 'assets/clouds.json';
      default:
        return 'assets/sunny.json'; // default animation
    }
  }

  // weather animation
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchWeather),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: $_errorMessage',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchWeather,
                    child: const Text('Retry'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // City name
                  Text(
                    _weather?.cityName ?? "Unknown City",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                  const SizedBox(height: 16),
                  // Temperature
                  Text(
                    '${_weather?.temperature.round().toString() ?? "--"}°C',
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 16),

                  // Weather condition
                  Text(
                    _weather?.mainCondition ?? "",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
      ),
    );
  }
}
