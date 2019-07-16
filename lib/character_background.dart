import 'package:flutter/material.dart';
import 'package:evolution/constants.dart';

class CharacterBackground extends CustomPainter {

  Paint _paint = Paint()
    ..color = strokeColor
    ..strokeWidth = 2.0;

  setColor(Color color) {
    _paint..color = color;
  }

  setStrokeWidth(double strokeWidth) {
    _paint..strokeWidth = strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _paint);
    _paint.style = PaintingStyle.fill;
    _paint.strokeWidth = 1.0;
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), _paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), _paint);
    canvas.drawLine(Offset(0, size.height/2), Offset(size.width, size.height/2), _paint);
    canvas.drawLine(Offset(size.width/2, 0), Offset(size.width/2, size.height), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}