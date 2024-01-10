import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

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
  final Duration gapDuration;
  DateTime centralDate;
/* -------------------------------------------------------------------------- */
  double get ratioGap => divisionGap / devicePixelRatio;
  double get ratioWidth => dividerWidth / devicePixelRatio;
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
    final Offset startingPoint = Offset(0, (size.height / 2));
    final Offset endingPoint = Offset(size.width / 2, size.height / 2);
    linePaint.strokeWidth = dividerWidth;

    var path = Path();

    canvas.drawLine(startingPoint, endingPoint, linePaint);
    canvas.translate(size.width / 2, 0);

    final drawer = _getDrawerFunction(
      canvas,
      path,
      size,
      centralDate,
    );
    drawer(size.width, _DrawDirection.future);
    drawer(size.width / 2, _DrawDirection.past);
  }

/* -------------------------------------------------------------------------- */
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

/* -------------------------------------------------------------------------- */
  Function(double, _DrawDirection) _getDrawerFunction(
    Canvas canvas,
    Path path,
    Size size,
    DateTime centralDate,
  ) {
    return (double drawLength, _DrawDirection direction) {
      _drawTimelinePart(
        canvas,
        path,
        size,
        centralDate,
        drawLength,
        direction,
      );
    };
  }

/* -------------------------------------------------------------------------- */
  void _drawTimelinePart(
    Canvas canvas,
    Path path,
    Size size,
    DateTime centralDate,
    double drawLength,
    _DrawDirection direction,
  ) {
    final duration =
        direction == _DrawDirection.future ? gapDuration : -gapDuration;
    int i = 0;

    for (double j = 0; j < drawLength; j += ratioGap + ratioWidth, i++) {
      if (centralDate.second % dividersAmount == 0) {
        _drawLargeDivision(
          canvas,
          path,
          size,
          Offset(
            direction.multiptier * (ratioWidth + ratioGap) * i - value,
            size.height / 2,
          ),
        );
        _drawTime(
          canvas,
          Offset(
            direction.multiptier * (ratioWidth + ratioGap) * i - value,
            size.height / 2,
          ),
          size,
          centralDate,
          true,
        );
      } else {
        _drawSmallDivision(
          canvas,
          path,
          size,
          Offset(
            direction.multiptier * (ratioGap + ratioWidth) * i - value,
            size.height / 2,
          ),
          linePaint,
        );
      }
      centralDate = centralDate.add(duration);
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
  void drawSmallDivision(
      Canvas canvas, Path path, Size size, Offset position) {
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
  void drawLargeDivision(
      Canvas canvas, Path path, Size size, Offset position) {
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
    String formattedDate = intl.DateFormat('hh:mm:ss').format(currentTime);

    var timeSpan = TextSpan(
      text: formattedDate,
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

enum _DrawDirection {
  future(1),
  past(-1);

  final int multiptier;
  const _DrawDirection(this.multiptier);
}
