// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API key
  final _weatherService = WeatherService('5e6dea358da0dee51537e6a0125488f8');
  Weather? _weather;

  // Fetch Weather
  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print('Detected City: $cityName'); // Debugging line

    if (cityName.isEmpty) {
      print('City name could not be determined.');
      return;
    }

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  String quote = "";
  String getQuoteBasedonWeather(int? id) {
    if (id == null) {
      return "";
    }
    switch (id) {
      case > 200 && <= 300:
        return "There is beauty in the way lightning dances across the sky.";
      case >= 300 && < 400:
        return '"The mountain remains unmoved at its seeming defeat by the mist."';
      case >= 500 && < 600:
        return '"Life\'s not about waiting for the storm to pass…It\'s about learning to dance in the rain."';
      case >= 600 && < 700:
        return '"Even the strongest blizzards start with a single snowflake."';
      case >= 700 && < 800:
        return '"It is the dim haze of mystery that adds enchantment to pursuit."';
      case == 800:
        return '"Whenever you want to see me, always look at the sunset; I will be there."';
      case > 800 && <= 804:
        return '"There\'s no such thing as bad weather,just soft people"';
      default:
        return '"Think I\'d rather be asleep right now \n Dream about some mistake I made"';
    }
  }

  String getWelcomeNote(Weather? weather) {
    if (weather == null) {
      return 'Loading..';
    }
    if (weather.time.hour.toInt() >= 5 && weather.time.hour.toInt() < 12) {
      return 'Good Morning!';
    } else if (weather.time.hour.toInt() >= 12 &&
        weather.time.hour.toInt() < 18) {
      return "Good Afternoon!";
    } else if (weather.time.hour.toInt() >= 18 &&
        weather.time.hour.toInt() <= 22) {
      return "Good Evening!";
    } else {
      return 'Have a Good Night!';
    }
  }

  // Get weather animation on behalf of the current weather
  String getWeatherAnimation(int? id) {
    if (id == null) {
      return 'assets/sunny.json';
    }
    switch (id) {
      case > 200 && <= 300:
        if (_weather!.time.hour.toInt() <= 18) {
          return 'assets/thunderrainy.json';
        } else {
          return 'assets/thunderrainynight.json';
        }
      case >= 300 && < 400:
        if ((_weather!.time.hour.toInt() <= 18)) {
          return 'assets/drizzle.json';
        } else {
          return 'assets/drizzlenight.json';
        }
      case >= 500 && < 600:
        if ((_weather!.time.hour.toInt() <= 18)) {
          return 'assets/rainy.json';
        } else {
          return 'assets/rainynight.json';
        }
      case >= 600 && < 700:
        if ((_weather!.time.hour.toInt() <= 18)) {
          return 'assets/snowy.json';
        } else {
          return 'assets/snowynight.json';
        }
      case >= 700 && < 800:
        if ((_weather!.time.hour.toInt() <= 18)) {
          return 'assets/mist.json';
        } else {
          return 'assets/mistnight.json';
        }
      case == 800:
        if ((_weather!.time.hour.toInt() <= 18)) {
          return 'assets/sunny.json';
        } else {
          return 'assets/night.json';
        }
      case > 800 && <= 804:
        return 'assets/cloudy.json';
      default:
        if ((_weather!.time.hour.toInt() <= 18)) {
          return 'assets/sunny.json';
        } else {
          return 'assets/night.json';
        }
    }
  }

  String date = DateFormat('EEEE d •  hh:mm a').format(DateTime.now());
  Future<void> _refresh() async {
    await _fetchWeather();
    getWelcomeNote(_weather);
    getWeatherAnimation(_weather?.id);
    date;
  }

  @override
  void initState() {
    super.initState();
    // fetch weather on startup
    _fetchWeather();
    getWelcomeNote(_weather);
    date;
  }

  @override
  Widget build(BuildContext context) {
    
    return 
    SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 1.20 * kToolbarHeight, 20.w, 20.h),
          child: Stack(
            children: [
              // Background Circles and Box
              Align(
                alignment:  AlignmentDirectional(3.w, -0.2.h),
                child: Container(
                  height: 300.h,
                  width: 300.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 219, 164, 233),
                  ),
                ),
              ),
              Align(
                alignment:  AlignmentDirectional(-3.w, -0.2.h),
                child: Container(
                  height: 300.h,
                  width: 300.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 219, 164, 233),
                  ),
                ),
              ),
              Align(
                alignment:  AlignmentDirectional(0.w, -1.2.h),
                child: Container(
                  height: 400.h,
                  width: 600.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color.fromARGB(255, 215, 128, 255),
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0.w, sigmaY: 100.0.h),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
              // Refresh Indicator
              RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(  // Added ScrollView for overflow handling
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                           
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(left: 5.0.w),
                                child: Text(
                                  '📍${_weather?.cityName ?? "Loading city.."}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                getWelcomeNote(_weather),
                                style:  TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Lottie.asset(
                                getWeatherAnimation(_weather?.id),
                                repeat: true,
                                height: 200.h,
                                width: 200.w,
                              ),
                              Center(
                                child: Text(
                                  '${_weather?.temperature.round()}°C',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'feels like ${_weather?.feelslike.round()}°C',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  (_weather?.mainCondition ?? "").toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Center(
                                child: Text(
                                  DateFormat('EEEE d MMM •  hh:mm a').format(
                                    _weather?.time ?? DateTime.now(),
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/11.png',
                                        scale: 8,
                                      ),
                                      SizedBox(width: 5.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Sunrise',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('hh:mm a').format(
                                              _weather?.sunrise ?? DateTime.now(),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 18.w),
                                      Image.asset(
                                        'assets/12.png',
                                        scale: 8.r,
                                      ),
                                      SizedBox(width: 5.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Sunset',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          SizedBox(height: 3.h),
                                          Text(
                                            DateFormat('hh:mm a').format(
                                              _weather?.sunset ?? DateTime.now(),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                               Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.0.h),
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/13.png',
                                        scale: 8.r,
                                      ),
                                      SizedBox(width: 5.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Temp Max',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          SizedBox(height: 3.h),
                                          Text(
                                            '${_weather?.temperaturemax} °C',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 18.w),
                                      Image.asset(
                                        'assets/14.png',
                                        scale: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Temp Min',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          SizedBox(height: 3.h),
                                          Text(
                                            '${_weather?.temperaturemin} °C',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Center(
                                child: SizedBox(
                                  child: Text(
                                    getQuoteBasedonWeather(_weather?.id),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
}