import 'package:flutter/material.dart';

class SmallLinePainter extends CustomPainter {
/* -------------------------------- Painters -------------------------------- */
  final Paint linePaint;
/* ------------------------------- Constructor ------------------------------ */
  const SmallLinePainter({required this.linePaint});
/* -------------------------------------------------------------------------- */
  factory SmallLinePainter.future() {
    final linePaint = Paint()
      ..color = Colors.indigoAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    return SmallLinePainter(linePaint: linePaint);
  }
/* -------------------------------------------------------------------------- */
  factory SmallLinePainter.past() {
    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    return SmallLinePainter(linePaint: linePaint);
  }
/* -------------------------------------------------------------------------- */
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height / 2);

    canvas.drawPath(path, linePaint);
  }

/* -------------------------------------------------------------------------- */
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
/* -------------------------------------------------------------------------- */
}
