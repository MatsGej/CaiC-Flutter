/*
 * SensorScannerPage.dart
 * 
 * This file defines the SensorScannerPage widget, which is a stateful widget that provides
 * a multi-sensor scanning interface. The page includes tabs for different sensor scanning
 * functionalities such as Bluetooth, Wi-Fi, Magnetometer, and Height (Barometer) scanning.
 * It also features a logging mechanism to display sensor data in real-time, which can be
 * toggled on and off using a button in the app bar.
 */

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
  late TabController _tabController; // Controller for managing tab selection
  final List<String> _logs = []; // List to store log messages
  late ScrollController
      _scrollController; // Controller for managing scroll position in the log display
  bool _loggingEnabled = true; // Flag to control logging

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 4, vsync: this); // Initialize the TabController with 4 tabs
    _scrollController = ScrollController(); // Initialize the ScrollController
    requestPermissions(); // Request necessary permissions
  }

  // Request necessary permissions for sensor access
  void requestPermissions() async {
    await Permissions.requestPermissions();
  }

  // Add a log message to the log list and scroll to the bottom of the log display
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

  // Toggle the logging state
  void _toggleLogging() {
    setState(() {
      _loggingEnabled = !_loggingEnabled;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Sensor Scanner'), // Title of the app bar
        bottom: TabBar(
          controller: _tabController, // Attach the TabController to the TabBar
          tabs: const [
            Tab(
                icon: Icon(Icons.bluetooth),
                text: "Bluetooth"), // Bluetooth tab
            Tab(icon: Icon(Icons.wifi), text: "Wi-Fi"), // Wi-Fi tab
            Tab(
                icon: Icon(Icons.explore),
                text: "Magnetometer"), // Magnetometer tab
            Tab(
                icon: Icon(Icons.height),
                text: "Height"), // Height (Barometer) tab
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_loggingEnabled
                ? Icons.pause
                : Icons.play_arrow), // Icon changes based on logging state
            onPressed: _toggleLogging, // Toggle logging when pressed
          ),
        ],
      ),
      body: TabBarView(
        controller:
            _tabController, // Attach the TabController to the TabBarView
        children: [
          bluetooth.BluetoothScanner(addLog: _addLog), // Bluetooth scanner
          wifi.WiFiScanner(addLog: _addLog), // Wi-Fi scanner
          magnetometer.MagnetometerScanner(
              addLog: _addLog), // Magnetometer scanner
          height.HeightScanner(addLog: _addLog), // Height (Barometer) scanner
        ],
      ),
      bottomSheet: widget.showLogPage && _loggingEnabled
          ? LogDisplay(
              logs: _logs,
              scrollController: _scrollController,
              loggingEnabled: _loggingEnabled, // Pass the flag to LogDisplay
            )
          : null, // Conditionally display the log area based on logging state
    );
  }
}
