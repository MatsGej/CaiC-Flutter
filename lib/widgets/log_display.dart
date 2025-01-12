import 'package:flutter/material.dart';

class LogDisplay extends StatelessWidget {
  final List<String> logs;
  final ScrollController scrollController;
  final bool loggingEnabled; // Add a flag to control logging

  const LogDisplay({
    Key? key,
    required this.logs,
    required this.scrollController,
    required this.loggingEnabled, // Add a flag to control logging
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.black,
      child: ListView.builder(
        controller: scrollController,
        itemCount:
            loggingEnabled ? logs.length : 0, // Conditionally display logs
        itemBuilder: (context, index) {
          return Text(
            logs[index],
            style: const TextStyle(color: Colors.white),
          );
        },
      ),
    );
  }
}
