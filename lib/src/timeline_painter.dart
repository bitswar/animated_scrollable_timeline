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
  static const double mainLineHeight = 44;
/* -------------------------------------------------------------------------- */
  final double largeDivisionHeight;
  final double smallDivisionHeight;
  final int dividersAmount;
  final double divisionGap;
  final double dividerWidth;
  final double devicePixelRatio;
  final double value;
  final Duration gapDuration;
  final String Function(DateTime) dateTimeFormat;
  DateTime centralDate;
/* -------------------------------------------------------------------------- */
  double get ratioGap => divisionGap / devicePixelRatio;
  double get ratioWidth => dividerWidth / devicePixelRatio;
/* -------------------------------- Painters -------------------------------- */
  final Paint linePaint;
/* -------------------------------------------------------------------------- */
  final Paint futureLinePaint;
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
    required this.dateTimeFormat,
    required this.linePaint,
    required this.futureLinePaint,
  });
/* -------------------------------------------------------------------------- */
  factory TimelinePainter.general({
    required double smallDivisionHeight,
    required double largeDivisionHeight,
    required double devicePixelRatio,
    required DateTime centralDate,
    required int dividersAmount,
    required double divisionGap,
    required double dividerWidth,
    required double value,
    required Duration gapDuration,
    required String Function(DateTime) dateTimeFormat,
  }) {
    final linePaint = Paint()
      ..color = Colors.indigoAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final futureLinePaint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    return TimelinePainter(
      smallDivisionHeight: smallDivisionHeight,
      largeDivisionHeight: largeDivisionHeight,
      devicePixelRatio: devicePixelRatio,
      centralDate: centralDate,
      dividersAmount: dividersAmount,
      divisionGap: divisionGap,
      dividerWidth: dividerWidth,
      value: value,
      gapDuration: gapDuration,
      dateTimeFormat: dateTimeFormat,
      linePaint: linePaint,
      futureLinePaint: futureLinePaint,
    );
  }
/* -------------------------------------------------------------------------- */
  @override
  void paint(Canvas canvas, Size size) {
    linePaint.strokeWidth = dividerWidth;
    canvas.translate(size.width / 2, 0);

    _drawTimelinePart(
        canvas, Path(), size, centralDate, size.width, _DrawDirection.future);
    _drawTimelinePart(
        canvas, Path(), size, centralDate, size.width, _DrawDirection.past);
  }

/* -------------------------------------------------------------------------- */
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is TimelinePainter) {
      return value != oldDelegate.value;
    }

    return false;
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
    final duration = gapDuration * direction.multiptier;
    final offsetY = size.height / 2;
    final painter =
        direction == _DrawDirection.future ? futureLinePaint : linePaint;

    int i = 0;
    for (double j = 0; j < drawLength; j += ratioGap + ratioWidth, i++) {
      if (centralDate.second % dividersAmount == 0) {
        _drawLargeDivision(
          canvas,
          path,
          size,
          Offset(
            direction.multiptier * (ratioWidth + ratioGap) * i - value,
            offsetY,
          ),
          painter,
        );
        _drawTime(
          canvas,
          Offset(
            direction.multiptier * (ratioWidth + ratioGap) * i - value,
            offsetY,
          ),
          size,
          centralDate,
          direction == _DrawDirection.past,
        );
      } else {
        _drawSmallDivision(
          canvas,
          path,
          size,
          Offset(
            direction.multiptier * (ratioGap + ratioWidth) * i - value,
            offsetY,
          ),
          painter,
        );
      }
      centralDate = centralDate.add(duration);
    }
  }

/* -------------------------------------------------------------------------- */
  void _drawSmallDivision(
    Canvas canvas,
    Path path,
    Size size,
    Offset position,
    Paint painter,
  ) {
    path.moveTo(position.dx, size.height / 2 - 4);
    path.lineTo(position.dx, size.height / 2 - smallDivisionHeight - 4);
    canvas.drawPath(path, painter);
  }

/* -------------------------------------------------------------------------- */
  void _drawLargeDivision(
    Canvas canvas,
    Path path,
    Size size,
    Offset position,
    Paint painter,
  ) {
    path.moveTo(position.dx, size.height / 2);
    path.lineTo(position.dx, size.height / 2 - largeDivisionHeight);
    canvas.drawPath(
      path,
      painter,
    );
  }

/* -------------------------------------------------------------------------- */
  void _drawTime(
    Canvas canvas,
    Offset position,
    Size size,
    DateTime currentTime,
    bool isPast,
  ) {
    String formattedDate = dateTimeFormat(currentTime);

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

/* -------------------------------------------------------------------------- */
enum _DrawDirection {
  future(1),
  past(-1);

  final int multiptier;
  const _DrawDirection(this.multiptier);
} /* -------------------------------------------------------------------------- */
