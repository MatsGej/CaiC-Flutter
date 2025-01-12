/*
 * height_scanner.dart
 * 
 * This file defines the HeightScanner widget, which is a stateful widget that provides
 * functionality for scanning barometric pressure and calculating height above ground.
 * The widget uses the sensors_plus package to access barometer data and displays the
 * pressure and calculated height in real-time. It also includes buttons to start and
 * stop the barometer scanning, and a logging mechanism to display sensor data.
 */

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

class HeightScanner extends StatefulWidget {
  final Function(String) addLog;

  const HeightScanner({required this.addLog});

  @override
  _HeightScannerState createState() => _HeightScannerState();
}

class _HeightScannerState extends State<HeightScanner> {
  StreamSubscription?
      _barometerSubscription; // Subscription to barometer events
  double _pressure = 0.0; // Variable to store the current pressure
  double _height = 0.0; // Variable to store the calculated height
  bool _hasBarometer = false; // Flag to indicate if the device has a barometer

  @override
  void initState() {
    super.initState();
    _checkBarometerAvailability(); // Check if the device has a barometer
  }

  // Check if the device has a barometer sensor
  void _checkBarometerAvailability() async {
    try {
      // Attempt to listen to the barometer stream to check availability
      _barometerSubscription = barometerEventStream().listen((event) {
        setState(() {
          _hasBarometer = true; // Barometer is available
        });
        _barometerSubscription
            ?.cancel(); // Cancel the subscription after checking
      });
    } catch (e) {
      widget.addLog('Barometer sensor not available: $e'); // Log the error
      setState(() {
        _hasBarometer = false; // Barometer is not available
      });
    }
  }

  // Start listening to barometer events and calculate height
  void _startBarometer() {
    if (_hasBarometer) {
      widget.addLog('Starting barometer...');
      _barometerSubscription = barometerEventStream().listen(
        (event) {
          if (mounted) {
            setState(() {
              _pressure = event.pressure; // Update the pressure
              _height = _calculateHeight(_pressure); // Calculate the height
              widget.addLog(
                  'Pressure: $_pressure, Height: $_height'); // Log the data
            });
          }
        },
        onError: (error) {
          widget.addLog('Error: $error'); // Log any errors
        },
        cancelOnError: true,
      );
    } else {
      widget.addLog('Barometer sensor not available.');
    }
  }

  // Stop listening to barometer events
  void _stopBarometer() {
    widget.addLog('Stopping barometer...');
    _barometerSubscription?.cancel();
  }

  // Calculate height above ground using the barometric formula
  double _calculateHeight(double pressure) {
    // Assuming standard atmospheric pressure at sea level is 1013.25 hPa
    const double seaLevelPressure = 1013.25;
    return 44330.0 * (1.0 - pow(pressure / seaLevelPressure, 0.1903));
  }

  @override
  void dispose() {
    _barometerSubscription?.cancel(); // Cancel the subscription when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Height Above Ground (m):',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          _hasBarometer
              ? 'Pressure: ${_pressure.toStringAsFixed(2)} hPa\nHeight: ${_height.toStringAsFixed(2)} m'
              : 'Barometer sensor not available on this device.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _hasBarometer ? _startBarometer : null,
          child: const Text('Start Barometer'),
        ),
        ElevatedButton(
          onPressed: _hasBarometer ? _stopBarometer : null,
          child: const Text('Stop Barometer'),
        ),
      ],
    );
  }
}
