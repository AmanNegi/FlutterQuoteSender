import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;
    Paint paint = Paint();
    Paint paint2 = Paint()..color = Colors.white10;
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, height * 0.40)
      ..quadraticBezierTo(width * 0.50, height * 0.60, width, height * 0.40)
      ..lineTo(width, 0)
      ..lineTo(0, 0)
      ..close();

    Path path2 = Path()
      ..moveTo(0, 0)
      ..lineTo(0, height * 0.43)
      ..quadraticBezierTo(width * 0.50, height * 0.63, width, height * 0.43)
      ..lineTo(width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
