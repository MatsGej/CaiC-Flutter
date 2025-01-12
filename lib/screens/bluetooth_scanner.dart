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
  final List<ScanResult> scanResults = [];
  StreamSubscription<List<ScanResult>>? _subscription;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    widget.addLog('Starting Bluetooth scan...');
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    _subscription = FlutterBluePlus.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          scanResults.clear();
          scanResults.addAll(results);
        });
        widget.addLog('Found ${results.length} Bluetooth devices.');
      }
    });
  }

  void stopScan() {
    widget.addLog('Stopping Bluetooth scan...');
    FlutterBluePlus.stopScan();
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _subscription?.cancel();
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
            itemCount: scanResults.length,
            itemBuilder: (context, index) {
              final result = scanResults[index];
              return ListTile(
                title: Text(
                  result.device.platformName.isNotEmpty
                      ? result.device.platformName
                      : 'Unknown Device',
                ),
                subtitle: Text('RSSI: ${result.rssi}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
