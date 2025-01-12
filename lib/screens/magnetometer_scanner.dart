/*
 * magnetometer_scanner.dart
 * 
 * This file defines the MagnetometerScanner widget, which is a stateful widget that provides
 * functionality for scanning magnetic field data using the magnetometer sensor. The widget
 * uses the sensors_plus package to access magnetometer data and displays the x, y, and z
 * components of the magnetic field in real-time. It also includes buttons to start and stop
 * the magnetometer scanning, and a logging mechanism to display sensor data.
 */

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

class MagnetometerScanner extends StatefulWidget {
  final Function(String) addLog;

  const MagnetometerScanner({required this.addLog});

  @override
  _MagnetometerScannerState createState() => _MagnetometerScannerState();
}

class _MagnetometerScannerState extends State<MagnetometerScanner> {
  StreamSubscription?
      _magnetometerSubscription; // Subscription to magnetometer events
  double _x = 0.0,
      _y = 0.0,
      _z =
          0.0; // Variables to store the x, y, and z components of the magnetic field

  // Start listening to magnetometer events
  void _startMagnetometer() {
    widget.addLog('Starting magnetometer...');
    _magnetometerSubscription = magnetometerEventStream().listen((event) {
      if (mounted) {
        setState(() {
          _x = event.x;
          _y = event.y;
          _z = event.z;
        });
        widget.addLog(
            'Magnetometer data: x=${event.x}, y=${event.y}, z=${event.z}');
      }
    });
  }

  // Stop listening to magnetometer events
  void _stopMagnetometer() {
    widget.addLog('Stopping magnetometer...');
    _magnetometerSubscription?.cancel();
    setState(() {
      _x = 0.0;
      _y = 0.0;
      _z = 0.0;
    });
  }

  @override
  void dispose() {
    _magnetometerSubscription
        ?.cancel(); // Cancel the subscription when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalFieldStrength = sqrt(_x * _x +
        _y * _y +
        _z * _z); // Calculate the total magnetic field strength
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Magnetic Field (µT):',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'X: ${_x.toStringAsFixed(2)} µT\n'
          'Y: ${_y.toStringAsFixed(2)} µT\n'
          'Z: ${_z.toStringAsFixed(2)} µT\n'
          'Total: ${totalFieldStrength.toStringAsFixed(2)} µT',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _startMagnetometer,
          child: const Text('Start Magnetometer'),
        ),
        ElevatedButton(
          onPressed: _stopMagnetometer,
          child: const Text('Stop Magnetometer'),
        ),
      ],
    );
  }
}
