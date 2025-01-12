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
  List<WiFiAccessPoint> wifiNetworks = [];
  Timer? _scanTimer;
  bool _isScanning = false;

  void _startScanning() {
    widget.addLog('Starting continuous Wi-Fi scan...');
    _isScanning = true;
    _scanTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      scanWiFi();
    });
  }

  void _stopScanning() {
    widget.addLog('Stopping continuous Wi-Fi scan...');
    _isScanning = false;
    _scanTimer?.cancel();
  }

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
    _scanTimer?.cancel();
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
              onPressed: _isScanning ? null : _startScanning,
              child: const Text('Start Scanning'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _isScanning ? _stopScanning : null,
              child: const Text('Stop Scanning'),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: wifiNetworks.length,
            itemBuilder: (context, index) {
              final network = wifiNetworks[index];
              return ListTile(
                title: Text(network.ssid),
                subtitle: Text('Signal Strength: ${network.level} dBm'),
              );
            },
          ),
        ),
      ],
    );
  }
}
