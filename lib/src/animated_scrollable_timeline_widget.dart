import 'dart:async';

import 'package:animated_scrollable_timeline/src/timeline_painter.dart';
import 'package:flutter/material.dart';

class AnimatedScrollableTimelineWidget extends StatefulWidget {
/* ------------------------------ Dependencies ------------------------------ */
  final double divisionGap;
/* -------------------------------------------------------------------------- */
  final double dividerWidth;
/* -------------------------------------------------------------------------- */
  final int dividersAmount;
/* -------------------------------------------------------------------------- */
  final Duration gapDuration;
/* -------------------------------------------------------------------------- */
  final bool scrollRight;
/* -------------------------------------------------------------------------- */
  final bool scrollLeft;
/* -------------------------------------------------------------------------- */
  final void Function(DateTime)? onChosedTime;
/* -------------------------------------------------------------------------- */
  final String Function(DateTime)? dateTimeFormat;
/* -------------------------------------------------------------------------- */
  final DateTime Function()? limitDateTime;
/* ------------------------------- Constructor ------------------------------ */
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
  });
/* -------------------------------------------------------------------------- */
  @override
  State<AnimatedScrollableTimelineWidget> createState() =>
      _AnimatedScrollableTimelineWidgetState();
}

class _AnimatedScrollableTimelineWidgetState
    extends State<AnimatedScrollableTimelineWidget>
    with SingleTickerProviderStateMixin {
/* -------------------------------------------------------------------------- */
  late Timer timer;
/* -------------------------------------------------------------------------- */
  late Animation animation;
/* -------------------------------------------------------------------------- */
  late AnimationController controller;
/* -------------------------------------------------------------------------- */
  double get ars => widget.dividerWidth + widget.divisionGap;
/* -------------------------------------------------------------------------- */
  DateTime currentTime = DateTime.now();
  DateTime startDragTime = DateTime.now();
  DateTime? limitTime;
  Duration timeOffset = Duration.zero;
  double animValue = 0;
  double animOffset = 0;
  bool animHand = true;
  double previousAnimationValue = 0;
/* -------------------------------------------------------------------------- */

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

  /* -------------------------------------------------------------------------- */
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

/* -------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return SizedBox.expand(
      child: RepaintBoundary(
        child: GestureDetector(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return GestureDetector(
                onHorizontalDragUpdate: horizontalDragHandle,
                onHorizontalDragStart: stopAnimate,
                onHorizontalDragEnd: startAnimate,
                child: CustomPaint(
                  painter: TimelinePainter(
                    dateTimeFormat: (dateTime) {
                      if (widget.dateTimeFormat != null) {
                        return widget.dateTimeFormat!.call(dateTime);
                      }
                      return dateTime.toString();
                    },
                    largeDivisionHeight: 36,
                    smallDivisionHeight: 12,
                    devicePixelRatio: pixelRatio,
                    centralDate: currentTime,
                    dividersAmount: widget.dividersAmount,
                    dividerWidth: widget.dividerWidth,
                    divisionGap: widget.divisionGap,
                    gapDuration: widget.gapDuration,
                    value: animHand ? animValue : animation.value,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

/* -------------------------------------------------------------------------- */
  void animationListener() {} // ! wtf?
/* -------------------------------------------------------------------------- */
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

/* -------------------------------------------------------------------------- */
  DateTime getNewCurrentTime(Duration offset) {
    return currentTime.add(widget.gapDuration).subtract(offset);
  }

/* -------------------------------------------------------------------------- */
  Duration computeFinalOffset() {
    if (animValue > 0) {
      return timeOffset - widget.gapDuration;
    }
    return timeOffset + widget.gapDuration;
  }

/* -------------------------------------------------------------------------- */
  void stopAnimate(DragStartDetails details) {
    controller.stop();
    startDragTime = DateTime.now();
    animHand = true;
  }

/* -------------------------------------------------------------------------- */
  void startAnimate(DragEndDetails details) {
    final millisecondsDiff = getMillisecondsDiff(animOffset);

    timeOffset = getNewOffset(millisecondsDiff);
    controller.forward();
    widget.onChosedTime?.call(currentTime);
  }

/* -------------------------------------------------------------------------- */
  int getMillisecondsDiff(double animationOffset) {
    final gapsDifference = animationOffset / ars;
    return (gapsDifference * widget.gapDuration.inMilliseconds).toInt();
  }

/* -------------------------------------------------------------------------- */
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

/* -------------------------------------------------------------------------- */
  void resetManualAnimation() {
    animOffset = 0;
    animValue = 0;
    previousAnimationValue = 0;
    timeOffset = Duration.zero;
    animHand = false;
  }

/* -------------------------------------------------------------------------- */
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

/* -------------------------------------------------------------------------- */
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
/* -------------------------------------------------------------------------- */
}
