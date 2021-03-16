// loading required packages
import 'dart:ui';
import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  Path _path;
  Paint _paint;

  PathPainter(this._path, this._paint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(this._path, this._paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
