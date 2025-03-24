import 'package:animated_scrollable_timeline/animated_scrollable_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Animated Scrollable Timeline",
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Animated Scrollable Timeline"),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedTimeline(
                dateTimeFormat: (dateTime) {
                  return DateFormat('HH:mm:ss').format(dateTime);
                },
              ),
            ),
            Positioned(
              top: 300,
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedTimeline(
                dateTimeFormat: (dateTime) {
                  return DateFormat('HH:mm:ss').format(dateTime);
                },
                divisionGap: 21,
                dividersAmount: 5,
              ),
            ),
            Positioned(
              top: 450,
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedTimeline(
                dateTimeFormat: (dateTime) {
                  return DateFormat('mm:ss').format(dateTime);
                },
                divisionGap: 21,
                dividersAmount: 10,
              ),
            ),
            AnimatedScrollableTimelineWidget(
              limitDateTime: () => DateTime.now(),
              scrollRight: true,
              scrollLeft: true,
              dateTimeFormat: (dateTime) {
                return DateFormat('HH:mm:ss').format(dateTime);
              },
            ),
          ],
        ),
      ),
    );
  }
}
