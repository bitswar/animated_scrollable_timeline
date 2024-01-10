import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
/* ------------------------------ Dependencies ------------------------------ */
  static const TextStyle timeStyle = TextStyle(
    color: Colors.indigoAccent,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );
  final double largeDivisionHeight;
  final double smallDivisionHeight;
  final int dividersAmount;
  final double divisionGap;
  final double dividerWidth;
  final double devicePixelRatio;
  final double value;
  final Duration gapDuration;
  DateTime centralDate;

/* -------------------------------- Painters -------------------------------- */
  var linePaint = Paint()
    ..color = Colors.indigoAccent
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

/* ------------------------------- Constructor ------------------------------ */
  TimelinePainter({
    required this.smallDivisionHeight,
    required this.largeDivisionHeight,
    required this.devicePixelRatio,
    required this.centralDate,
    required this.dividersAmount,
    required this.divisionGap,
    required this.dividerWidth,
    required this.value,
    required this.gapDuration,
  });
/* -------------------------------------------------------------------------- */
  @override
  void paint(Canvas canvas, Size size) {
    final double ratioGap = divisionGap / devicePixelRatio;
    final double ratioWidth = dividerWidth / devicePixelRatio;
    final Offset startingPoint = Offset(0, (size.height / 2));
    final Offset endingPoint = Offset(size.width * 1.2, size.height / 2);
    linePaint.strokeWidth = dividerWidth;

    var path = Path();

    canvas.drawLine(startingPoint, endingPoint, linePaint);
    canvas.translate(size.width / 2, 0);

    // drawDivisions(canvas, path, size, centralDate, ratioGap, ratioWidth);
    drawPastTimeline(canvas, path, size, centralDate, ratioGap, ratioWidth);
    drawFutureTimeline(canvas, path, size, centralDate, ratioGap, ratioWidth);

    // canvas.drawPath(path, linePaint);
  }

/* -------------------------------------------------------------------------- */
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

/* -------------------------------------------------------------------------- */
  void drawFutureTimeline(
    Canvas canvas,
    Path path,
    Size size,
    DateTime centralDate,
    double ratioGap,
    double ratioWidth,
  ) {
    double futureHalfWidth = 0;
    int i = 0;

    while (futureHalfWidth <= size.width) {
      if (centralDate.second % dividersAmount != 0) {
        drawSmallDivision(
          canvas,
          path,
          size,
          Offset(
            i * (ratioGap + ratioWidth) - value,
            size.height / 2,
          ),
        );
      } else {
        drawLargeDivision(
          canvas,
          path,
          size,
          Offset(
            i * (ratioGap + ratioWidth) - value,
            size.height / 2,
          ),
        );
        drawTime(
          canvas,
          Offset(
            i * (ratioGap + ratioWidth) - value,
            size.height / 2,
          ),
          size,
          centralDate,
        );
      }
      futureHalfWidth += ratioGap + ratioWidth;
      centralDate = centralDate.add(gapDuration);
      i++;
    }
  }

/* -------------------------------------------------------------------------- */
  void drawPastTimeline(
    Canvas canvas,
    Path path,
    Size size,
    DateTime centralDate,
    double ratioGap,
    double ratioWidth,
  ) {
    double pastHalfWidth = size.width / 2;
    double i = 0;

    while (pastHalfWidth >= 0) {
      if (centralDate.second % dividersAmount == 0) {
        drawLargeDivision(
          canvas,
          path,
          size,
          Offset(
            -(ratioWidth + ratioGap) * i - value,
            size.height / 2,
          ),
        );
        drawTime(
          canvas,
          Offset(
            -(ratioWidth + ratioGap) * i - value,
            size.height / 2,
          ),
          size,
          centralDate,
        );
      } else {
        drawSmallDivision(
          canvas,
          path,
          size,
          Offset(
            -(ratioGap + ratioWidth) * i - value,
            size.height / 2,
          ),
        );
      }
      pastHalfWidth -= (ratioGap + ratioWidth);
      centralDate = centralDate.add(-gapDuration);
      i++;
    }
  }

/* -------------------------------------------------------------------------- */
  void drawSmallDivision(Canvas canvas, Path path, Size size, Offset position) {
    path.moveTo(position.dx, size.height / 2 - 4);
    path.lineTo(position.dx, size.height / 2 - smallDivisionHeight - 4);
    canvas.drawPath(path, linePaint);
  }

/* -------------------------------------------------------------------------- */
  void drawLargeDivision(Canvas canvas, Path path, Size size, Offset position) {
    path.moveTo(position.dx, size.height / 2);
    path.lineTo(position.dx, size.height / 2 - largeDivisionHeight);
    canvas.drawPath(path, linePaint);
  }

/* -------------------------------------------------------------------------- */
  void drawTime(
    Canvas canvas,
    Offset position,
    Size size,
    DateTime currentTime,
  ) {
    var timeSpan = TextSpan(
      text:
          '${currentTime.hour.toString()}:${currentTime.minute.toString()}:${currentTime.second.toString()}',
      style: timeStyle,
    );

    TextPainter textPainter = TextPainter(
      text: timeSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(
        canvas, Offset(position.dx + 4, position.dy - largeDivisionHeight - 2));
  }

/* -------------------------------------------------------------------------- */
}
