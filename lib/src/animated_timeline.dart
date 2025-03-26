import 'package:animated_scrollable_timeline/src/past_part_painter.dart';
import 'package:animated_scrollable_timeline/src/timeline_painter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget that displays an animated timeline without scrolling functionality.
///
/// This widget provides a basic timeline visualization that automatically
/// animates through time. It's useful for displaying a static or
/// programmatically animated timeline without user interaction.
///
/// The timeline displays time divisions with customizable appearance,
/// including support for past and future time periods and custom time formatting.
class AnimatedTimeline extends StatefulWidget {
  /// Width of the timeline dividers in logical pixels.
  final double dividerWidth;

  /// Gap between divisions in logical pixels.
  final double divisionGap;

  /// Number of dividers to show on each side of the timeline.
  final int dividersAmount;

  /// Time gap between divisions.
  final Duration gapDuration;

  /// Height of large divisions in logical pixels.
  final double largeDivisionHeight;

  /// Height of small divisions in logical pixels.
  final double smallDivisionHeight;

  /// DateFormat to use for displaying time labels.
  /// If not provided, uses the default format (HH:mm:ss).
  final DateFormat? dateFormat;

  /// Creates a new [AnimatedTimeline].
  ///
  /// All parameters except [currentTime] are optional and have default values:
  /// - [dividerWidth]: 1.0
  /// - [divisionGap]: 21.0
  /// - [dividersAmount]: 10
  /// - [gapDuration]: 1 second
  /// - [largeDivisionHeight]: 36.0
  /// - [smallDivisionHeight]: 12.0
  /// - [dateFormat]: HH:mm:ss
  const AnimatedTimeline({
    super.key,
    this.dividerWidth = 1,
    this.divisionGap = 21,
    this.dividersAmount = 10,
    this.gapDuration = const Duration(seconds: 1),
    this.largeDivisionHeight = 36,
    this.smallDivisionHeight = 12,
    this.dateFormat,
  });

  @override
  State<AnimatedTimeline> createState() => _AnimatedTimelineState();
}

class _AnimatedTimelineState extends State<AnimatedTimeline>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = AnimationController(
      vsync: this,
      duration: widget.gapDuration,
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              painter: TimelinePainter.general(
                repaint: controller,
                dateFormat: widget.dateFormat ?? DateFormat('HH:mm:ss'),
                largeDivisionHeight: widget.largeDivisionHeight,
                smallDivisionHeight: widget.smallDivisionHeight,
                devicePixelRatio: pixelRatio,
                dividersAmount: widget.dividersAmount,
                dividerWidth: widget.dividerWidth,
                divisionGap: widget.divisionGap,
                gapDuration: widget.gapDuration,
              ),
            ),
          ),
          RepaintBoundary(
            child: CustomPaint(
              painter: PastPartPainter.general(),
              willChange: false,
              isComplex: false,
            ),
          ),
        ],
      ),
    );
  }
}
