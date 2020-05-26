import 'package:flutter/material.dart';

class SmallCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var x = size.width;
    var y = size.height;

    Paint paint = new Paint()..color = Colors.white24
    ..maskFilter = MaskFilter.blur(BlurStyle.solid, 10.0);
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, y * 0.150)
      ..quadraticBezierTo(x * 0.5, y * 0.250, x, y * 0.150)
      ..lineTo(x, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
