/*
 * bluetooth_scanner.dart
 * 
 * This file defines the BluetoothScanner widget, which is a stateful widget that provides
 * functionality for scanning Bluetooth devices. The widget uses the flutter_blue_plus package
 * to access Bluetooth data and displays the available devices in real-time. It includes buttons
 * to start and stop Bluetooth scanning, and a logging mechanism to display scan results.
 */

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

class BluetoothScanner extends StatefulWidget {
  final Function(String) addLog;

  const BluetoothScanner({required this.addLog});

  @override
  _BluetoothScannerState createState() => _BluetoothScannerState();
}

class _BluetoothScannerState extends State<BluetoothScanner> {
  final List<ScanResult> scanResults =
      []; // List to store Bluetooth scan results
  StreamSubscription<List<ScanResult>>?
      _subscription; // Subscription to scan results stream

  @override
  void initState() {
    super.initState();
    startScan(); // Start scanning for Bluetooth devices when the widget is initialized
  }

  // Start scanning for Bluetooth devices
  void startScan() {
    widget.addLog('Starting Bluetooth scan...');
    FlutterBluePlus.startScan(
        timeout: const Duration(
            seconds: 10)); // Start scanning with a timeout of 10 seconds
    _subscription = FlutterBluePlus.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          scanResults.clear(); // Clear previous scan results
          scanResults.addAll(results); // Add new scan results
        });
        widget.addLog('Found ${results.length} Bluetooth devices.');
      }
    });
  }

  // Stop scanning for Bluetooth devices
  void stopScan() {
    widget.addLog('Stopping Bluetooth scan...');
    FlutterBluePlus.stopScan(); // Stop scanning
    _subscription?.cancel(); // Cancel the subscription
    _subscription = null;
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancel the subscription when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: startScan,
          child: const Text('Start Bluetooth Scan'),
        ),
        ElevatedButton(
          onPressed: stopScan,
          child: const Text('Stop Bluetooth Scan'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: scanResults.length, // Number of Bluetooth devices found
            itemBuilder: (context, index) {
              final result = scanResults[index];
              return ListTile(
                title: Text(
                  result.device.platformName.isNotEmpty
                      ? result.device.platformName
                      : 'Unknown Device', // Display device name or 'Unknown Device'
                ),
                subtitle: Text(
                    'RSSI: ${result.rssi}'), // Display RSSI (signal strength)
              );
            },
          ),
        ),
      ],
    );
  }
}
