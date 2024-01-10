import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animated_scrollable_timeline/timeline_painter.dart';

class AnimatedScrollableTimelineWidget extends StatefulWidget {
/* ------------------------------ Dependencies ------------------------------ */
  final double divisionGap;
/* -------------------------------------------------------------------------- */
  final double dividerWidth;
/* -------------------------------------------------------------------------- */
  final int dividersAmount;
/* -------------------------------------------------------------------------- */
  final Duration gapDuration;
/* ------------------------------- Constructor ------------------------------ */
  const AnimatedScrollableTimelineWidget({
    super.key,
    this.dividerWidth = 1,
    this.divisionGap = 21,
    this.dividersAmount = 10,
    this.gapDuration = const Duration(seconds: 1),
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
  Duration timeOffset = Duration.zero;
  DateTime startDragTime = DateTime.now();
  double animValue = 0;
  double animOffset = 0;
  bool animHand = true;
  double previousAnimationValue = 0;
/* -------------------------------------------------------------------------- */
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.gapDuration,
    )
      ..addStatusListener(animationStatusListener)
      ..addListener(animationListener);

    animation = Tween<double>(begin: 0, end: ars).animate(controller);
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

  void animationListener() {}

  void animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controller.reset();
      setState(() {
        if (animValue != 0) {
          timeOffset = computeFinalOffset();
        }
        currentTime = currentTime.add(widget.gapDuration).subtract(timeOffset);
        resetManualAnimation();
      });
      if (animValue == 0 && !animHand) {
        controller.forward();
      }
    }
  }

  Duration computeFinalOffset() {
    if (animValue > 0) {
      return timeOffset - widget.gapDuration;
    }
    return timeOffset + widget.gapDuration;
  }

  void stopAnimate(DragStartDetails details) {
    controller.stop();
    startDragTime = DateTime.now();
    animHand = true;
  }

  void startAnimate(DragEndDetails details) {
    final gapsDifference = animOffset / ars;
    final millisecondsDiff =
        (gapsDifference * widget.gapDuration.inMilliseconds).toInt();

    if (millisecondsDiff < 0) {
      // Forward
      timeOffset = Duration(
        milliseconds: timeOffset.inMilliseconds - millisecondsDiff.abs(),
      );
    } else {
      // Backward
      timeOffset = Duration(
        milliseconds: (timeOffset.inMilliseconds - millisecondsDiff).abs(),
      );
    }

    controller.forward();
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
    animOffset += offset.dx;
    setState(() {
      changeAnimValue(offset.dx);
    });
  }

  void changeAnimValue(double value) {
    setState(() {
      animValue -= value;
    });
  }
/* -------------------------------------------------------------------------- */
}
