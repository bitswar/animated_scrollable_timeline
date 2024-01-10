import 'package:flutter/material.dart';
import 'package:animated_scrollable_timeline/animated_scrollable_timeline_widget.dart';

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
      title: "Painting example",
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Painting Example"),
        ),
        body: Stack(
          children: [
            AnimatedScrollableTimelineWidget(
              limitDateTime: () => DateTime.now(),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2,
              top: MediaQuery.of(context).size.height / 2 - 100,
              child: Container(
                width: 4,
                height: 44,
                color: Colors.indigoAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
