import 'package:flutter/material.dart';

class PastPartPainter extends CustomPainter {
/* ------------------------------ Dependencies ------------------------------ */
  final double mainLineHeight;
/* -------------------------------------------------------------------------- */
  final double dividerWidth;
/* -------------------------------- Painters -------------------------------- */
  final Paint linePaint;
/* -------------------------------------------------------------------------- */
  final Paint mainLinePaint;
/* -------------------------------------------------------------------------- */
  final Paint rectLinePaint;
/* ------------------------------- Constructor ------------------------------ */
  PastPartPainter({
    required this.linePaint,
    required this.mainLinePaint,
    required this.rectLinePaint,
    this.mainLineHeight = 44,
    this.dividerWidth = 1,
  });
/* -------------------------------------------------------------------------- */
  factory PastPartPainter.general() {
    return PastPartPainter(
      linePaint: Paint()
        ..color = Colors.indigoAccent
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
      mainLinePaint: Paint()
        ..color = Colors.indigoAccent
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
      rectLinePaint: Paint()
        ..color = Colors.indigo.withOpacity(0.15)
        ..style = PaintingStyle.fill,
    );
  }
/* -------------------------------------------------------------------------- */
  @override
  void paint(Canvas canvas, Size size) {
    linePaint.strokeWidth = dividerWidth;

    _drawBottomLine(canvas, size);
    canvas.translate(size.width / 2, 0);
    _drawPastRectangle(canvas, size);
    _drawMiddleDivider(canvas, size);
  }

/* -------------------------------------------------------------------------- */
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

/* -------------------------------------------------------------------------- */
  void _drawBottomLine(Canvas canvas, Size size) {
    final Offset startingPoint = Offset(0, (size.height / 2));
    final Offset endingPoint = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(startingPoint, endingPoint, linePaint);
  }

/* -------------------------------------------------------------------------- */
  void _drawMiddleDivider(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(0, size.height / 2 - mainLineHeight),
      mainLinePaint,
    );
  }

/* -------------------------------------------------------------------------- */
  void _drawPastRectangle(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromPoints(
        Offset(-size.width, size.height / 2 - mainLineHeight),
        Offset(0, size.height / 2),
      ),
      rectLinePaint,
    );
  }
/* -------------------------------------------------------------------------- */
}
