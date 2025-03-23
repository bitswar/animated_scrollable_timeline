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

- Two timeline widgets:
  - `AnimatedScrollableTimelineWidget`: Interactive timeline with scrolling and gesture support
  - `AnimatedTimeline`: Simple animated timeline without scrolling
- Smooth animations for time progression
- Customizable time divisions and gaps
- Support for both left and right scrolling (in scrollable version)
- Custom date/time formatting
- Time limit constraints (in scrollable version)
- Gesture-based interaction (in scrollable version)
- High-performance rendering with `RepaintBoundary`

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  animated_scrollable_timeline: any
```

## Development

This project uses [Melos](https://melos.invertase.dev/) for managing the development workflow. To get started:

1. Install Melos:
```bash
dart pub global activate melos
```

2. Setup the project:
```bash
melos bootstrap
```

3. Available commands:
- `melos run analyze` - Run static analysis
- `melos run test` - Run tests
- `melos run version` - Version the package
- `melos run publish` - Publish to pub.dev
- `melos run clean` - Clean the project

## Usage

### AnimatedScrollableTimelineWidget

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
  largeDivisionHeight: 36, // Height of large divisions
  smallDivisionHeight: 12, // Height of small divisions
)
```

### AnimatedTimeline

Here's an example of how to use the simpler `AnimatedTimeline`:

```dart
import 'package:animated_scrollable_timeline/animated_scrollable_timeline.dart';

// Inside your widget tree
AnimatedTimeline(
  dividerWidth: 1, // Width of the timeline dividers
  divisionGap: 21, // Gap between divisions
  dividersAmount: 10, // Number of dividers to show
  gapDuration: const Duration(seconds: 1), // Time gap between divisions
  currentTime: DateTime.now(), // Current time to display
  dateTimeFormat: (DateTime dateTime) {
    // Custom date/time formatting
    return '${dateTime.hour}:${dateTime.minute}';
  },
  largeDivisionHeight: 36, // Height of large divisions
  smallDivisionHeight: 12, // Height of small divisions
)
```

## Properties

### AnimatedScrollableTimelineWidget

- `dividerWidth`: Width of the timeline dividers (default: 1)
- `divisionGap`: Gap between divisions (default: 21)
- `dividersAmount`: Number of dividers to show (default: 10)
- `gapDuration`: Time gap between divisions (default: 1 second)
- `scrollRight`: Enable scrolling to the right (default: true)
- `scrollLeft`: Enable scrolling to the left (default: true)
- `onChosedTime`: Callback function when a time is selected
- `dateTimeFormat`: Custom function to format the date/time display
- `limitDateTime`: Optional function to set a time limit
- `largeDivisionHeight`: Height of large divisions (default: 36)
- `smallDivisionHeight`: Height of small divisions (default: 12)

### AnimatedTimeline

- `dividerWidth`: Width of the timeline dividers (default: 1)
- `divisionGap`: Gap between divisions (default: 21)
- `dividersAmount`: Number of dividers to show (default: 10)
- `gapDuration`: Time gap between divisions (default: 1 second)
- `currentTime`: Current time to display in the timeline
- `dateTimeFormat`: Custom function to format the date/time display
- `largeDivisionHeight`: Height of large divisions (default: 36)
- `smallDivisionHeight`: Height of small divisions (default: 12)

## Requirements

- Flutter SDK >= 1.17.0
- Dart SDK >= 3.0.0

## License

This project is licensed under the MIT License - see the LICENSE file for details.
