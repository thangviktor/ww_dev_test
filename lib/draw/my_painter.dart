import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'models/drawing_point.dart';

class MyPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;
  final ui.Image? backgroundImage;

  MyPainter({
    required this.drawingPoints,
    this.backgroundImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (backgroundImage != null) {
      canvas.drawImageRect(
        backgroundImage!,
        Rect.fromLTWH(
          0,
          0,
          backgroundImage!.width.toDouble(),
          backgroundImage!.height.toDouble(),
        ),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint(),
      );
    }

    try {
      for (var drawingPoint in drawingPoints) {
        final paint = Paint()
          ..color = drawingPoint.color
          ..strokeWidth = drawingPoint.width
          ..strokeCap = StrokeCap.round;

        for (var i = 0; i < drawingPoint.offsets.length; i++) {
          var notLastOffset = i != drawingPoint.offsets.length - 1;

          if (notLastOffset) {
            final current = drawingPoint.offsets[i];
            final next = drawingPoint.offsets[i + 1];
            canvas.drawLine(current, next, paint);
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
