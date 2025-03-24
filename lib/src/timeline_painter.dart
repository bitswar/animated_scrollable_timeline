import 'package:animated_scrollable_timeline/src/enums/draw_direction.dart';
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
  final Duration gapDuration;
  final String Function(DateTime) dateTimeFormat;
  DateTime _offsetDate = DateTime.now();
/* -------------------------------------------------------------------------- */
  double get ratioGap => divisionGap / devicePixelRatio;
  double get ratioWidth => dividerWidth / devicePixelRatio;
/* -------------------------------- Painters -------------------------------- */
  final Paint linePaint;
/* -------------------------------------------------------------------------- */
  final Paint futureLinePaint;
/* ------------------------------- Constructor ------------------------------ */
  TimelinePainter({
    super.repaint,
    required this.smallDivisionHeight,
    required this.largeDivisionHeight,
    required this.devicePixelRatio,
    required this.dividersAmount,
    required this.divisionGap,
    required this.dividerWidth,
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
    required int dividersAmount,
    required double divisionGap,
    required double dividerWidth,
    required Duration gapDuration,
    required String Function(DateTime) dateTimeFormat,
    Listenable? repaint,
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
      dividersAmount: dividersAmount,
      divisionGap: divisionGap,
      dividerWidth: dividerWidth,
      gapDuration: gapDuration,
      dateTimeFormat: dateTimeFormat,
      repaint: repaint,
      linePaint: linePaint,
      futureLinePaint: futureLinePaint,
    );
  }
/* -------------------------------------------------------------------------- */
  @override
  void paint(Canvas canvas, Size size) {
    _offsetDate = DateTime.now();

    linePaint.strokeWidth = dividerWidth;
    canvas.translate(size.width / 2, 0);

    _drawTimelinePart(
        canvas, Path(), size, _offsetDate, size.width, DrawDirection.future);
    _drawTimelinePart(
        canvas, Path(), size, _offsetDate, size.width, DrawDirection.past);
  }

/* -------------------------------------------------------------------------- */
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

/* -------------------------------------------------------------------------- */
  void _drawTimelinePart(
    Canvas canvas,
    Path path,
    Size size,
    DateTime centralDate,
    double drawLength,
    DrawDirection direction,
  ) {
    final duration = gapDuration * direction.multiplier;
    final offsetY = size.height / 2;
    final painter =
        direction == DrawDirection.future ? futureLinePaint : linePaint;

    final smoothValue =
        (ratioWidth + ratioGap) * (_offsetDate.millisecond / 1000);

    int i = 0;
    for (double j = 0; j < drawLength; j += ratioGap + ratioWidth, i++) {
      final offsetX =
          direction.multiplier * (ratioWidth + ratioGap) * i - smoothValue;
      if (centralDate.second % dividersAmount == 0) {
        _drawLargeDivision(
          canvas,
          path,
          size,
          Offset(offsetX, offsetY),
          painter,
        );
        _drawTime(
          canvas,
          Offset(offsetX, offsetY),
          size,
          centralDate,
          direction == DrawDirection.past,
        );
      } else {
        _drawSmallDivision(
          canvas,
          path,
          size,
          Offset(offsetX, offsetY),
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
