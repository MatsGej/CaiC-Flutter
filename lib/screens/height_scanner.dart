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
  StreamSubscription? _barometerSubscription;
  double _pressure = 0.0;
  double _height = 0.0;
  bool _hasBarometer = false;

  @override
  void initState() {
    super.initState();
    _checkBarometerAvailability();
  }

  void _checkBarometerAvailability() async {
    try {
      // Attempt to listen to the barometer stream to check availability
      _barometerSubscription = barometerEventStream().listen((event) {
        setState(() {
          _hasBarometer = true;
        });
        _barometerSubscription?.cancel();
      });
    } catch (e) {
      widget.addLog('Barometer sensor not available: $e');
      setState(() {
        _hasBarometer = false;
      });
    }
  }

  void _startBarometer() {
    if (_hasBarometer) {
      widget.addLog('Starting barometer...');
      _barometerSubscription = barometerEventStream().listen(
        (event) {
          if (mounted) {
            setState(() {
              _pressure = event.pressure;
              _height = _calculateHeight(_pressure);
              widget.addLog('Pressure: $_pressure, Height: $_height');
            });
          }
        },
        onError: (error) {
          widget.addLog('Error: $error');
        },
        cancelOnError: true,
      );
    } else {
      widget.addLog('Barometer sensor not available.');
    }
  }

  void _stopBarometer() {
    widget.addLog('Stopping barometer...');
    _barometerSubscription?.cancel();
  }

  double _calculateHeight(double pressure) {
    // Calculate height above ground using the barometric formula
    // Assuming standard atmospheric pressure at sea level is 1013.25 hPa
    const double seaLevelPressure = 1013.25;
    return 44330.0 * (1.0 - pow(pressure / seaLevelPressure, 0.1903));
  }

  @override
  void dispose() {
    _barometerSubscription?.cancel();
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
