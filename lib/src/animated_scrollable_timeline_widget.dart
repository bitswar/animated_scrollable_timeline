import 'dart:async';

import 'package:animated_scrollable_timeline/src/past_part_painter.dart';
import 'package:animated_scrollable_timeline/src/timeline_painter.dart';
import 'package:flutter/material.dart';

/// A widget that displays an animated timeline with scrolling functionality.
///
/// This widget provides a horizontally scrollable timeline that can be used to
/// display and navigate through time-based data. It supports both automatic
/// animation and user interaction through horizontal scrolling.
///
/// The timeline displays time divisions with customizable appearance and behavior,
/// including support for past and future time periods, custom time formatting,
/// and time limits.
class AnimatedScrollableTimelineWidget extends StatefulWidget {
  /// Width of the timeline dividers in logical pixels.
  final double dividerWidth;

  /// Gap between divisions in logical pixels.
  final double divisionGap;

  /// Number of dividers to show on each side of the timeline.
  final int dividersAmount;

  /// Time gap between divisions.
  final Duration gapDuration;

  /// Whether scrolling to the right (future) is enabled.
  final bool scrollRight;

  /// Whether scrolling to the left (past) is enabled.
  final bool scrollLeft;

  /// Callback function that is called when a time is selected through scrolling.
  final void Function(DateTime)? onChosedTime;

  /// Function to format the date/time display.
  /// If not provided, uses the default format.
  final String Function(DateTime)? dateTimeFormat;

  /// Function to get the time limit for scrolling.
  /// If not provided, no time limit is enforced.
  final DateTime Function()? limitDateTime;

  /// Height of large divisions in logical pixels.
  final double largeDivisionHeight;

  /// Height of small divisions in logical pixels.
  final double smallDivisionHeight;

  /// Creates a new [AnimatedScrollableTimelineWidget].
  ///
  /// All parameters are optional and have default values:
  /// - [dividerWidth]: 1.0
  /// - [divisionGap]: 21.0
  /// - [dividersAmount]: 10
  /// - [gapDuration]: 1 second
  /// - [scrollRight]: true
  /// - [scrollLeft]: true
  /// - [largeDivisionHeight]: 36.0
  /// - [smallDivisionHeight]: 12.0
  ///
  /// The [dateTimeFormat], [onChosedTime], and [limitDateTime] callbacks are optional.
  const AnimatedScrollableTimelineWidget({
    super.key,
    this.dividerWidth = 1,
    this.divisionGap = 21,
    this.dividersAmount = 10,
    this.gapDuration = const Duration(seconds: 1),
    this.scrollRight = true,
    this.scrollLeft = true,
    this.limitDateTime,
    this.onChosedTime,
    this.dateTimeFormat,
    this.largeDivisionHeight = 36,
    this.smallDivisionHeight = 12,
  });

  static String _defaultDateTimeFormat(DateTime dateTime) =>
      dateTime.toString();

  @override
  State<AnimatedScrollableTimelineWidget> createState() =>
      _AnimatedScrollableTimelineWidgetState();
}

class _AnimatedScrollableTimelineWidgetState
    extends State<AnimatedScrollableTimelineWidget>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  late Animation animation;
  late AnimationController controller;
  double get ars => widget.dividerWidth + widget.divisionGap;
  DateTime currentTime = DateTime.now();
  DateTime startDragTime = DateTime.now();
  DateTime? limitTime;
  Duration timeOffset = Duration.zero;
  double animValue = 0;
  double animOffset = 0;
  bool animHand = true;
  double previousAnimationValue = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    limitTime = widget.limitDateTime?.call();
    controller = AnimationController(
      vsync: this,
      duration: widget.gapDuration,
    )
      ..addStatusListener(animationStatusListener)
      ..addListener(animationListener);

    animation =
        Tween<double>(begin: 0, end: ars / pixelRatio).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.removeStatusListener(animationStatusListener);
    controller.removeListener(animationListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return SizedBox.expand(
      child: GestureDetector(
        onHorizontalDragUpdate: horizontalDragHandle,
        onHorizontalDragStart: stopAnimate,
        onHorizontalDragEnd: startAnimate,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return RepaintBoundary(
                  child: CustomPaint(
                    isComplex: true,
                    painter: TimelinePainter.general(
                      repaint: controller,
                      dateTimeFormat: widget.dateTimeFormat ??
                          AnimatedScrollableTimelineWidget
                              ._defaultDateTimeFormat,
                      largeDivisionHeight: widget.largeDivisionHeight,
                      smallDivisionHeight: widget.smallDivisionHeight,
                      devicePixelRatio: pixelRatio,
                      dividersAmount: widget.dividersAmount,
                      dividerWidth: widget.dividerWidth,
                      divisionGap: widget.divisionGap,
                      gapDuration: widget.gapDuration,
                    ),
                  ),
                );
              },
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
      ),
    );
  }

  void animationListener() {} // ! wtf?
  void animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controller.reset();
      setState(() {
        if (animValue != 0) {
          timeOffset = computeFinalOffset();
        }
        currentTime = currentTime.add(widget.gapDuration).subtract(timeOffset);
        limitTime = widget.limitDateTime?.call();
        resetManualAnimation();
      });
      if (animValue == 0 && !animHand) {
        controller.forward();
      }
    }
  }

  DateTime getNewCurrentTime(Duration offset) {
    return currentTime.add(widget.gapDuration).subtract(offset);
  }

  Duration computeFinalOffset() {
    if (animValue > 0) {
      return timeOffset - widget.gapDuration;
    }
    return timeOffset + widget.gapDuration;
  }

  void stopAnimate(DragStartDetails details) {
    if (!widget.scrollRight && !widget.scrollLeft) {
      return;
    }

    controller.stop();
    startDragTime = DateTime.now();
    animHand = true;
  }

  void startAnimate(DragEndDetails details) {
    if (!widget.scrollRight && !widget.scrollLeft) {
      return;
    }
    final millisecondsDiff = getMillisecondsDiff(animOffset);

    timeOffset = getNewOffset(millisecondsDiff);
    controller.forward();
    widget.onChosedTime?.call(currentTime);
  }

  int getMillisecondsDiff(double animationOffset) {
    final gapsDifference = animationOffset / ars;
    return (gapsDifference * widget.gapDuration.inMilliseconds).toInt();
  }

  Duration getNewOffset(int millisecondsDiff) {
    if (millisecondsDiff < 0) {
      // Forward
      return Duration(
        milliseconds: timeOffset.inMilliseconds - millisecondsDiff.abs(),
      );
    } else {
      // Backward
      return Duration(
        milliseconds: (timeOffset.inMilliseconds - millisecondsDiff).abs(),
      );
    }
  }

  void resetManualAnimation() {
    animOffset = 0;
    animValue = 0;
    previousAnimationValue = 0;
    timeOffset = Duration.zero;
    animHand = false;
  }

  void horizontalDragHandle(DragUpdateDetails details) {
    final offset = details.delta;

    if (!widget.scrollRight && offset.dx < 0) {
      return;
    }

    if (!widget.scrollLeft && offset.dx > 0) {
      return;
    }

    if (!canScrollLimitCheck(animOffset + offset.dx)) {
      return;
    }

    animOffset += offset.dx;
    setState(() {
      changeAnimValue(offset.dx);
    });
  }

  bool canScrollLimitCheck(double offset) {
    final millisecondsDiff = getMillisecondsDiff(offset);
    final newOffset = getNewOffset(millisecondsDiff);

    final newTime = getNewCurrentTime(newOffset);

    if (limitTime == null) {
      return true;
    }

    if (newTime.compareTo(limitTime!) < 1) {
      return true;
    }

    return false;
  }

  void changeAnimValue(double value) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    setState(() {
      animValue -= value / pixelRatio;
    });
  }
}
