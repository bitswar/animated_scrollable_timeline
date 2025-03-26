import 'package:animated_scrollable_timeline/src/enums/draw_direction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

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
  final DateFormat dateFormat;
  final Path _path;
  final TextPainter _textPainter;
  late TextSpan _textSpan;
  DateTime _offsetDate = DateTime.now();
/* -------------------------------------------------------------------------- */
  double get ratioGap => divisionGap / devicePixelRatio;
  double get ratioWidth => dividerWidth / devicePixelRatio;
/* -------------------------------- Painters -------------------------------- */
  final Paint linePaint;
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
    required this.dateFormat,
    required this.linePaint,
    required this.futureLinePaint,
  })  : _path = Path(),
        _textPainter = TextPainter(
          textDirection: TextDirection.ltr,
        ) {
    _textSpan = const TextSpan(text: '', style: pastStyle);
  }
/* -------------------------------------------------------------------------- */
  factory TimelinePainter.general({
    required double smallDivisionHeight,
    required double largeDivisionHeight,
    required double devicePixelRatio,
    required int dividersAmount,
    required double divisionGap,
    required double dividerWidth,
    required Duration gapDuration,
    required DateFormat dateFormat,
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
      dateFormat: dateFormat,
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
        canvas, size, _offsetDate, size.width, DrawDirection.future);
    _drawTimelinePart(
        canvas, size, _offsetDate, size.width, DrawDirection.past);
  }

/* -------------------------------------------------------------------------- */
  @override
  bool shouldRepaint(covariant TimelinePainter oldDelegate) {
    return false;
  }

/* -------------------------------------------------------------------------- */
  void _drawDivision(
    Canvas canvas,
    Offset position,
    Paint painter, {
    required double height,
  }) {
    _path.reset();
    _path.moveTo(position.dx, position.dy);
    _path.lineTo(position.dx, position.dy - height);
    canvas.drawPath(_path, painter);
  }

/* -------------------------------------------------------------------------- */
  void _drawTimelinePart(
    Canvas canvas,
    Size size,
    DateTime centralDate,
    double drawLength,
    DrawDirection direction,
  ) {
    final duration = gapDuration * direction.multiplier;
    final centerY = size.height / 2;
    final painter =
        direction == DrawDirection.future ? futureLinePaint : linePaint;

    final smoothValue =
        (ratioWidth + ratioGap) * (_offsetDate.millisecond / 1000);

    int i = 0;
    for (double j = 0; j < drawLength; j += ratioGap + ratioWidth, i++) {
      final offsetX =
          direction.multiplier * (ratioWidth + ratioGap) * i - smoothValue;

      if (centralDate.second % dividersAmount == 0) {
        _drawDivision(
          canvas,
          Offset(offsetX, centerY),
          painter,
          height: largeDivisionHeight,
        );
        _drawTime(
          canvas,
          Offset(offsetX, centerY),
          size,
          centralDate,
          direction == DrawDirection.past,
        );
      } else {
        _drawDivision(
          canvas,
          Offset(offsetX, centerY - 4),
          painter,
          height: smallDivisionHeight,
        );
      }
      centralDate = centralDate.add(duration);
    }
  }

/* -------------------------------------------------------------------------- */
  void _drawTime(
    Canvas canvas,
    Offset position,
    Size size,
    DateTime currentTime,
    bool isPast,
  ) {
    _textSpan = TextSpan(
      text: dateFormat.format(currentTime),
      style: isPast ? pastStyle : futureStyle,
    );
    _textPainter.text = _textSpan;

    _textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    _textPainter.paint(
        canvas, Offset(position.dx + 4, position.dy - largeDivisionHeight - 2));
  }
/* -------------------------------------------------------------------------- */
}
