import 'package:flutter/material.dart';

class DrawingPoint {
  List<Offset> offsets;
  Color color;
  double width;

  DrawingPoint({
    this.offsets = const [],
    this.color = Colors.black,
    this.width = 2,
  });

  DrawingPoint copyWith({List<Offset>? offsets}) {
    return DrawingPoint(
      color: color,
      width: width,
      offsets: offsets ?? this.offsets,
    );
  }
}
