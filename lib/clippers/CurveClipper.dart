import 'package:flutter/material.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var width = size.width;
    var height = size.height;
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, height * 0.70)
      ..quadraticBezierTo(width * 0.50, height, width, height * 0.70)
      ..lineTo(width, 0)
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
