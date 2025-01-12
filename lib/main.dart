import 'package:flutter/material.dart';
import 'screens/sensor_scanner_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Sensor Scanner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SensorScannerPage(
          showLogPage: true), // Set to false to hide the log page
    );
  }
}
