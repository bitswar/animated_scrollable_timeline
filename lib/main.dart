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
            const AnimatedScrollableTimelineWidget(),
            Center(
              child: Container(
                width: 2,
                height: 50,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
