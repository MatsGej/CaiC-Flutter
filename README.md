# My Flutter App

This is a Flutter application that collects information from a number of sensors and displays it on the screen.
It is the first step to create the flutter part of a fingerprinting application.
The app includes various sensor scanning functionalities such as Bluetooth, Wi-Fi, Magnetometer, and Height (Barometer) scanning. It also features a logging mechanism to display sensor data in real-time.

## Project Structure

```
my_flutter_app
├── lib
│   ├── main.dart                # Entry point of the application
│   ├── screens
│   │   └── home_screen.dart     # Main screen of the application
│   ├── widgets
│   │   └── custom_widget.dart    # Custom reusable widget
├── pubspec.yaml                 # Project configuration and dependencies
├── android                      # Android-specific configuration and code
├── ios                          # iOS-specific configuration and code
├── test
│   └── widget_test.dart         # Widget tests for the application
└── README.md                    # Documentation for the project
```

## Getting Started

To get started with this project, follow these steps:

1. **Clone the repository:**
   ```
   git clone <repository-url>
   cd my_flutter_app
   ```

2. **Install dependencies:**
   ```
   flutter pub get
   ```

3. **Run the application:**
   ```
   flutter run
   ```

## Usage

- The main screen can be accessed through the `SensorScannerPage` widget located in `lib/screens/sensor_scanner_page.dart`.
- The app includes tabs for different sensor scanning functionalities:
  - **Bluetooth**: Scans for nearby Bluetooth devices.
  - **Wi-Fi**: Scans for available Wi-Fi networks.
  - **Magnetometer**: Scans for magnetic field data.
  - **Height (Barometer)**: Scans for barometric pressure and calculates height above ground.
- Custom widgets can be found in `lib/widgets/log_display.dart` and can be reused throughout the application.

## Logging

- The app features a logging mechanism to display sensor data in real-time.
- Logs can be toggled on and off using the button in the app bar.
- When logging is enabled, sensor data is displayed in the `LogDisplay` widget.

## Contributing

Feel free to submit issues or pull requests for improvements or bug fixes.