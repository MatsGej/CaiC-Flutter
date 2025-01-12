/*
 * main.dart
 * 
 * This file is the entry point of the Flutter application. It defines the main function, which is the starting
 * point of the app, and the MyApp widget, which sets up the MaterialApp and the home screen of the application.
 * The home screen is set to the SensorScannerPage widget, which provides a multi-sensor scanning interface.
 */

import 'package:flutter/material.dart';
import 'screens/sensor_scanner_page.dart';

// The main function is the entry point of the Flutter application.
void main() {
  runApp(const MyApp());
}

// MyApp is a stateless widget that sets up the MaterialApp and the home screen of the application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Sensor Scanner', // Title of the application
      theme: ThemeData(
          primarySwatch: Colors.blue), // Set the primary color theme to blue
      home: const SensorScannerPage(
          showLogPage:
              true), // Set the home screen to SensorScannerPage with logging enabled
    );
  }
}
