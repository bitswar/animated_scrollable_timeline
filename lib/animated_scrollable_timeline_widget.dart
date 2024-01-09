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
/* -------------------------------------------------------------------------- */
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          setState(() {
            currentTime = DateTime.now();
          });
          print(status);
          controller.forward();
        }
      });
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
              return CustomPaint(
                painter: TimelinePainter(
                  largeDivisionHeight: 36,
                  smallDivisionHeight: 12,
                  devicePixelRatio: pixelRatio,
                  centralDate: currentTime,
                  dividersAmount: widget.dividersAmount,
                  dividerWidth: widget.dividerWidth,
                  divisionGap: widget.divisionGap,
                  value: controller.value,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

/* -------------------------------------------------------------------------- */
}
