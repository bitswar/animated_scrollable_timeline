import 'dart:async';

import 'package:animated_scrollable_timeline/src/past_part_painter.dart';
import 'package:animated_scrollable_timeline/src/timeline_painter.dart';
import 'package:flutter/material.dart';

class AnimatedTimeline extends StatefulWidget {
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
/* -------------------------------------------------------------------------- */
  final double largeDivisionHeight;
/* -------------------------------------------------------------------------- */
  final double smallDivisionHeight;
/* ------------------------------- Constructor ------------------------------ */
  const AnimatedTimeline({
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

  String _defaultDateTimeFormat(DateTime dateTime) {
    if (dateTimeFormat != null) {
      return dateTimeFormat!.call(dateTime);
    }
    return dateTime.toString();
  }

/* -------------------------------------------------------------------------- */
  @override
  State<AnimatedTimeline> createState() => _AnimatedTimelineState();
}

class _AnimatedTimelineState extends State<AnimatedTimeline>
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
  DateTime? limitTime;
  Duration timeOffset = Duration.zero;
/* -------------------------------------------------------------------------- */

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    limitTime = widget.limitDateTime?.call();
    controller = AnimationController(
      vsync: this,
      duration: widget.gapDuration,
    )..addStatusListener(animationStatusListener);

    animation =
        Tween<double>(begin: 0, end: ars / pixelRatio).animate(controller);
    controller.forward();
  }

  /* -------------------------------------------------------------------------- */
  @override
  void dispose() {
    controller.removeStatusListener(animationStatusListener);
    controller.dispose();
    super.dispose();
  }

/* -------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return SizedBox.expand(
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
                    dateTimeFormat:
                        widget.dateTimeFormat ?? widget._defaultDateTimeFormat,
                    largeDivisionHeight: widget.largeDivisionHeight,
                    smallDivisionHeight: widget.smallDivisionHeight,
                    devicePixelRatio: pixelRatio,
                    centralDate: currentTime,
                    dividersAmount: widget.dividersAmount,
                    dividerWidth: widget.dividerWidth,
                    divisionGap: widget.divisionGap,
                    gapDuration: widget.gapDuration,
                    value: animation.value,
                  ),
                ),
              );
            },
          ),
          CustomPaint(
            painter: PastPartPainter.general(),
            willChange: false,
            isComplex: false,
          ),
        ],
      ),
    );
  }

/* -------------------------------------------------------------------------- */
  void animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controller.reset();
      setState(() {
        currentTime = currentTime.add(widget.gapDuration).subtract(timeOffset);
        limitTime = widget.limitDateTime?.call();
      });
      controller.forward();
    }
  }
/* -------------------------------------------------------------------------- */
}
