/*
 * LogDisplay.dart
 * 
 * This file defines the LogDisplay widget, which is a stateless widget that displays a list of log messages.
 * The log messages are displayed in a scrollable list, and the visibility of the logs can be controlled
 * using the loggingEnabled flag. The widget also uses a ScrollController to manage the scroll position.
 */

import 'package:flutter/material.dart';

class LogDisplay extends StatelessWidget {
  final List<String> logs; // List of log messages to display
  final ScrollController
      scrollController; // Controller for managing scroll position
  final bool loggingEnabled; // Flag to control logging visibility

  const LogDisplay({
    Key? key,
    required this.logs,
    required this.scrollController,
    required this.loggingEnabled, // Add a flag to control logging
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Set the height of the log display container
      color:
          Colors.black, // Set the background color of the log display container
      child: ListView.builder(
        controller:
            scrollController, // Attach the ScrollController to the ListView
        itemCount: loggingEnabled
            ? logs.length
            : 0, // Conditionally display logs based on loggingEnabled flag
        itemBuilder: (context, index) {
          return Text(
            logs[index], // Display each log message
            style: const TextStyle(
                color: Colors.white), // Set the text color to white
          );
        },
      ),
    );
  }
}
