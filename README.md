<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->


# Animated Scrollable Timeline

A Flutter widget that provides an infinite scrollable timeline with smooth animations. This widget is particularly useful for implementing real-time streaming components, such as video playback timelines or time-based data visualization.
![animated timeline](https://github.com/user-attachments/assets/884cc7a5-89f0-4702-ac14-ac5a3c5e4547)

## Features

- Infinite horizontal scrolling timeline
- Smooth animations for time progression
- Customizable time divisions and gaps
- Support for both left and right scrolling
- Custom date/time formatting
- Time limit constraints
- Gesture-based interaction
- High-performance rendering with `RepaintBoundary`

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  animated_scrollable_timeline: ^0.0.6
```

## Usage

Here's a basic example of how to use the `AnimatedScrollableTimelineWidget`:

```dart

import 'package:animated_scrollable_timeline/animated_scrollable_timeline.dart';

// Inside your widget tree
AnimatedScrollableTimelineWidget(
  dividerWidth: 1, // Width of the timeline dividers
  divisionGap: 21, // Gap between divisions
  dividersAmount: 10, // Number of dividers to show
  gapDuration: const Duration(seconds: 1), // Time gap between divisions
  scrollRight: true, // Enable scrolling to the right
  scrollLeft: true, // Enable scrolling to the left
  onChosedTime: (DateTime time) {
    // Callback when a time is selected
    print('Selected time: $time');
  },
  dateTimeFormat: (DateTime dateTime) {
    // Custom date/time formatting
    return '${dateTime.hour}:${dateTime.minute}';
  },
  limitDateTime: () {
    // Optional time limit
    return DateTime.now().add(const Duration(hours: 24));
  },
)
```

## Properties

- `dividerWidth`: Width of the timeline dividers (default: 1)
- `divisionGap`: Gap between divisions (default: 21)
- `dividersAmount`: Number of dividers to show (default: 10)
- `gapDuration`: Time gap between divisions (default: 1 second)
- `scrollRight`: Enable scrolling to the right (default: true)
- `scrollLeft`: Enable scrolling to the left (default: true)
- `onChosedTime`: Callback function when a time is selected
- `dateTimeFormat`: Custom function to format the date/time display
- `limitDateTime`: Optional function to set a time limit

## Requirements

- Flutter SDK >= 1.17.0
- Dart SDK >= 3.0.0

## License

This project is licensed under the MIT License - see the LICENSE file for details.
