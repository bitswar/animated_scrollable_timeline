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

    final drawer = _getDrawerFunction(
      canvas,
      path,
      size,
      centralDate,
      ratioGap,
      ratioWidth,
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
    double ratioGap,
    double ratioWidth,
  ) {
    return (double drawLength, _DrawDirection direction) {
      _drawTimelinePart(
        canvas,
        path,
        size,
        centralDate,
        ratioGap,
        ratioWidth,
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
    double ratioGap,
    double ratioWidth,
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
        );
      }
      centralDate = centralDate.add(duration);
    }
  }

/* -------------------------------------------------------------------------- */
  void _drawSmallDivision(
      Canvas canvas, Path path, Size size, Offset position) {
    path.moveTo(position.dx, size.height / 2 - 4);
    path.lineTo(position.dx, size.height / 2 - smallDivisionHeight - 4);
    canvas.drawPath(path, linePaint);
  }

/* -------------------------------------------------------------------------- */
  void _drawLargeDivision(
      Canvas canvas, Path path, Size size, Offset position) {
    path.moveTo(position.dx, size.height / 2);
    path.lineTo(position.dx, size.height / 2 - largeDivisionHeight);
    canvas.drawPath(path, linePaint);
  }

/* -------------------------------------------------------------------------- */
  void _drawTime(
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

enum _DrawDirection {
  future(1),
  past(-1);

  final int multiptier;
  const _DrawDirection(this.multiptier);
}
