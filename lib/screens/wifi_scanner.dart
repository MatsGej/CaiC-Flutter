/*
 * wifi_scanner.dart
 * 
 * This file defines the WiFiScanner widget, which is a stateful widget that provides
 * functionality for scanning Wi-Fi networks. The widget uses the wifi_scan package to
 * access Wi-Fi data and displays the available networks in real-time. It includes buttons
 * to start and stop continuous Wi-Fi scanning, and a logging mechanism to display scan results.
 */

import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'dart:async';

class WiFiScanner extends StatefulWidget {
  final Function(String) addLog;

  const WiFiScanner({required this.addLog});

  @override
  _WiFiScannerState createState() => _WiFiScannerState();
}

class _WiFiScannerState extends State<WiFiScanner> {
  List<WiFiAccessPoint> wifiNetworks = []; // List to store Wi-Fi networks
  Timer? _scanTimer; // Timer for continuous scanning
  bool _isScanning = false; // Flag to indicate if scanning is active

  // Start continuous Wi-Fi scanning
  void _startScanning() {
    widget.addLog('Starting continuous Wi-Fi scan...');
    setState(() {
      _isScanning = true;
    });
    _scanTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      scanWiFi();
    });
  }

  // Stop continuous Wi-Fi scanning
  void _stopScanning() {
    widget.addLog('Stopping continuous Wi-Fi scan...');
    setState(() {
      _isScanning = false;
    });
    _scanTimer?.cancel();
  }

  // Scan for Wi-Fi networks
  void scanWiFi() async {
    widget.addLog('Scanning Wi-Fi networks...');
    await WiFiScan.instance.startScan();
    final networks = await WiFiScan.instance.getScannedResults();
    if (mounted) {
      setState(() {
        wifiNetworks = networks;
      });
      widget.addLog('Found ${networks.length} Wi-Fi networks.');
    }
  }

  @override
  void dispose() {
    _scanTimer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isScanning
                  ? null
                  : _startScanning, // Disable button if already scanning
              child: const Text('Start Scanning'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _isScanning
                  ? _stopScanning
                  : null, // Disable button if not scanning
              child: const Text('Stop Scanning'),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: wifiNetworks.length, // Number of Wi-Fi networks found
            itemBuilder: (context, index) {
              final network = wifiNetworks[index];
              return ListTile(
                title: Text(network.ssid), // Display SSID of the network
                subtitle: Text(
                    'Signal Strength: ${network.level} dBm'), // Display signal strength
              );
            },
          ),
        ),
      ],
    );
  }
}
