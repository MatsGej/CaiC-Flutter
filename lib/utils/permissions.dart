/*
 * permissions.dart
 * 
 * This file defines the Permissions class, which provides a method to request necessary
 * permissions for the application. The class uses the permission_handler package to
 * request permissions for Bluetooth, Bluetooth scanning, Bluetooth connection, and location.
 */

import 'package:permission_handler/permission_handler.dart';

class Permissions {
  // Static method to request necessary permissions
  static Future<void> requestPermissions() async {
    // Request permissions for Bluetooth, Bluetooth scanning, Bluetooth connection, and location
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }
}
