import 'package:flutter/material.dart';
import '../utils/permissions.dart';
import '../widgets/log_display.dart';
import 'bluetooth_scanner.dart' as bluetooth;
import 'wifi_scanner.dart' as wifi;
import 'magnetometer_scanner.dart' as magnetometer;
import 'height_scanner.dart' as height;

class SensorScannerPage extends StatefulWidget {
  final bool showLogPage;

  const SensorScannerPage({Key? key, this.showLogPage = true})
      : super(key: key);

  @override
  _SensorScannerPageState createState() => _SensorScannerPageState();
}

class _SensorScannerPageState extends State<SensorScannerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _logs = [];
  late ScrollController _scrollController;
  bool _loggingEnabled = true; // Add a flag to control logging

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    requestPermissions();
  }

  void requestPermissions() async {
    await Permissions.requestPermissions();
  }

  void _addLog(String log) {
    if (_loggingEnabled) {
      // Check if logging is enabled
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _logs.add(log);
            // Scroll to the bottom of the list
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      });
    }
  }

  void _toggleLogging() {
    setState(() {
      _loggingEnabled = !_loggingEnabled;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Sensor Scanner'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.bluetooth), text: "Bluetooth"),
            Tab(icon: Icon(Icons.wifi), text: "Wi-Fi"),
            Tab(icon: Icon(Icons.explore), text: "Magnetometer"),
            Tab(icon: Icon(Icons.height), text: "Height"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_loggingEnabled ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleLogging,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          bluetooth.BluetoothScanner(addLog: _addLog),
          wifi.WiFiScanner(addLog: _addLog),
          magnetometer.MagnetometerScanner(addLog: _addLog),
          height.HeightScanner(addLog: _addLog),
        ],
      ),
      bottomSheet: widget.showLogPage && _loggingEnabled
          ? LogDisplay(
              logs: _logs,
              scrollController: _scrollController,
              loggingEnabled: _loggingEnabled, // Pass the flag to LogDisplay
            )
          : null,
    );
  }
}
