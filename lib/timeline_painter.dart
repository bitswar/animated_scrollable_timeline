import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
/* ------------------------------ Dependencies ------------------------------ */
  static const TextStyle pastStyle = TextStyle(
    color: Colors.indigoAccent,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle futureStyle = TextStyle(
    color: Colors.grey,
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
  });
/* -------------------------------------------------------------------------- */
  @override
  void paint(Canvas canvas, Size size) {
    final double ratioGap = divisionGap / devicePixelRatio;
    final double ratioWidth = dividerWidth / devicePixelRatio;
    final Offset startingPoint = Offset(0, (size.height / 2));
    final Offset endingPoint = Offset(size.width / 2, size.height / 2);
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
    var futureLinePaint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double futureHalfWidth = 0;
    int i = 0;

    while (futureHalfWidth <= size.width) {
      if (centralDate.second % dividersAmount != 0) {
        drawSmallDivision(
          canvas,
          path,
          size,
          Offset(
            i * (ratioGap + ratioWidth) - (ratioWidth + ratioGap) * value,
            size.height / 2,
          ),
          futureLinePaint,
        );
      } else {
        drawLargeDivision(
          canvas,
          path,
          size,
          Offset(
            i * (ratioGap + ratioWidth) - (ratioWidth + ratioGap) * value,
            size.height / 2,
          ),
          futureLinePaint,
        );
        drawTime(
          canvas,
          Offset(
            i * (ratioGap + ratioWidth) - (ratioWidth + ratioGap) * value,
            size.height / 2,
          ),
          size,
          centralDate,
          false,
        );
      }
      futureHalfWidth += ratioGap + ratioWidth;
      centralDate = centralDate.add(const Duration(seconds: 1));
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
              -(ratioWidth + ratioGap) * i - (ratioWidth + ratioGap) * value,
              size.height / 2,
            ),
            linePaint);
        drawTime(
          canvas,
          Offset(
            -(ratioWidth + ratioGap) * i - (ratioWidth + ratioGap) * value,
            size.height / 2,
          ),
          size,
          centralDate,
          true,
        );
      } else {
        drawSmallDivision(
          canvas,
          path,
          size,
          Offset(
            -(ratioGap + ratioWidth) * i - (ratioWidth + ratioGap) * value,
            size.height / 2,
          ),
          linePaint,
        );
      }
      pastHalfWidth -= (ratioGap + ratioWidth);
      centralDate = centralDate.add(const Duration(seconds: -1));
      i++;
    }
  }

/* -------------------------------------------------------------------------- */
  void drawSmallDivision(
    Canvas canvas,
    Path path,
    Size size,
    Offset position,
    Paint paint,
  ) {
    path.moveTo(position.dx, size.height / 2 - 4);
    path.lineTo(position.dx, size.height / 2 - smallDivisionHeight - 4);
    canvas.drawPath(path, paint);
  }

/* -------------------------------------------------------------------------- */
  void drawLargeDivision(
    Canvas canvas,
    Path path,
    Size size,
    Offset position,
    Paint paint,
  ) {
    path.moveTo(position.dx, size.height / 2);
    path.lineTo(position.dx, size.height / 2 - largeDivisionHeight);
    canvas.drawPath(path, paint);
  }

/* -------------------------------------------------------------------------- */
  void drawTime(
    Canvas canvas,
    Offset position,
    Size size,
    DateTime currentTime,
    bool isPast,
  ) {
    var timeSpan = TextSpan(
      text:
          '${currentTime.hour.toString()}:${currentTime.minute.toString()}:${currentTime.second.toString()}',
      style: isPast ? pastStyle : futureStyle,
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
