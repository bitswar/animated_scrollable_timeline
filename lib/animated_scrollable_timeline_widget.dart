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
/* ------------------------------- Constructor ------------------------------ */
  const AnimatedScrollableTimelineWidget({
    super.key,
    this.dividerWidth = 1,
    this.divisionGap = 21,
    this.dividersAmount = 10,
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
  DateTime currentTime = DateTime.now();
  Duration timeOffset = const Duration(seconds: 0);
  DateTime startDragTime = DateTime.now();
  double animValue = 0;
  int animOffset = 0;
  bool animHand = false;
/* -------------------------------------------------------------------------- */
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          setState(() {
            currentTime = DateTime.now().subtract(timeOffset);
          });
          debugPrint(status.toString());
          controller.forward();
        }
      })
      ..addListener(() {});
    animation = Tween<double>(
      begin: 0,
      end: widget.dividerWidth + widget.divisionGap,
    ).animate(controller);

    controller.forward();
    super.initState();
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

  void stopAnimate(DragStartDetails details) {
    animHand = true;
    startDragTime = DateTime.now();
    controller.stop();
  }

  void startAnimate(DragEndDetails details) {
    final addSeconds = animOffset ~/ 20;
    final difference = startDragTime.difference(DateTime.now());
    timeOffset = Duration(
      seconds: addSeconds + timeOffset.inSeconds - difference.inSeconds,
    );
    print("TimeOffset: $timeOffset");

    animHand = false;
    animValue = 0;
    animOffset = 0;
    controller.forward();
  }

  void horizontalDragHandle(DragUpdateDetails details) {
    final offset = details.delta;
    animOffset += offset.dx.toInt();
    setState(() {
      changeAnimValue(offset.dx);
    });
  }

  void changeAnimValue(double value) {
    print(value);
    setState(() {
      animValue -= value;
    });
    print(animValue);
  }
/* -------------------------------------------------------------------------- */
}
