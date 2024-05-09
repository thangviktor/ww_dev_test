import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../utils.dart';
import 'models/drawing_point.dart';
import 'models/pallet.dart';
import 'models/sticker.dart';
import 'my_painter.dart';

class DrawFrame extends StatefulWidget {
  const DrawFrame({
    super.key,
    required this.selectedColor,
    required this.selectedWidth,
    required this.stickers,
    required this.requestCapture,
  });

  final Color selectedColor;
  final double selectedWidth;
  final List<Sticker> stickers;
  final bool requestCapture;

  @override
  State<DrawFrame> createState() => _DrawFrameState();
}

class _DrawFrameState extends State<DrawFrame> {
  final frameSize = screenWidth - 32;

  final drawingPoints = <DrawingPoint>[];

  var selectedColor = pallet.first;
  var selectedWidth = 2.0;

  DrawingPoint? currentDrawingPoint;

  late List<Sticker> stickers;
  Sticker? selectedSticker;

  double frameMarginTop = appBarAndStatusBarHeight + 69;
  double frameMarginLeft = 25;

  final backgroundImageKey = GlobalKey();
  ui.Image? backgroundImage;

  @override
  Widget build(BuildContext context) {
    if (widget.requestCapture) {
      selectedSticker = null;
    }

    selectedColor = widget.selectedColor;
    selectedWidth = widget.selectedWidth;
    stickers = widget.stickers;

    return Container(
      width: frameSize,
      height: frameSize,
      color: Colors.white,
      child: Stack(
        children: [
          RepaintBoundary(
            key: backgroundImageKey,
            child: GestureDetector(
              onPanStart: startDraw,
              onPanUpdate: drawing,
              onPanEnd: finishDraw,
              child: CustomPaint(
                painter: MyPainter(
                  drawingPoints: drawingPoints,
                  backgroundImage: backgroundImage,
                ),
                child: Container(),
              ),
            ),
          ),
          Stack(
            children: List<Positioned>.generate(
                stickers.length,
                (index) => Positioned(
                      left: stickers[index].offset.dx - frameMarginLeft,
                      top: stickers[index].offset.dy - frameMarginTop,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            stickers[index].offset = Offset(
                                stickers[index].offset.dx + details.delta.dx,
                                stickers[index].offset.dy + details.delta.dy);
                          });
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Colors.grey,
                                    style: selectedSticker == stickers[index]
                                        ? BorderStyle.solid
                                        : BorderStyle.none),
                              ),
                              child: TapRegion(
                                onTapInside: (_) async {
                                  await Future.delayed(const Duration(milliseconds: 150));
                                  setState(() {
                                    selectedSticker = stickers[index];
                                  });
                                },
                                onTapOutside: (_) async {
                                  await Future.delayed(const Duration(milliseconds: 100));
                                  setState(() {
                                    selectedSticker = null;
                                  });
                                },
                                child: Image.asset(stickers[index].image),
                              ),
                            ),
                            Visibility(
                                visible: selectedSticker == stickers[index],
                                child: GestureDetector(
                                    onTap: () => removeSticker(index),
                                    child: const Icon(Icons.remove_circle)))
                          ],
                        ),
                      ),
                    )),
          )
        ],
      ),
    );
  }

  void startDraw(DragStartDetails details) {
    setState(() {
      currentDrawingPoint = DrawingPoint(
        offsets: [
          details.localPosition,
        ],
        color: selectedColor,
        width: selectedWidth,
      );

      drawingPoints.add(currentDrawingPoint!);
    });
  }

  void drawing(DragUpdateDetails details) {
    if (details.localPosition.dx < selectedWidth / 2 ||
        details.localPosition.dx > frameSize - selectedWidth / 2 ||
        details.localPosition.dy < selectedWidth / 2 ||
        details.localPosition.dy > frameSize - selectedWidth / 2) return;

    setState(() {
      if (currentDrawingPoint == null) return;

      currentDrawingPoint = currentDrawingPoint?.copyWith(
        offsets: currentDrawingPoint!.offsets..add(details.localPosition),
      );
      drawingPoints.last = currentDrawingPoint!;
    });
  }

  void finishDraw(DragEndDetails details) async {
    currentDrawingPoint = null;

    if (drawingPoints.length > 10) {
      log('drawingPoints.l = ${drawingPoints.length}');
      RenderRepaintBoundary boundary =
          backgroundImageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      backgroundImage = await boundary.toImage(pixelRatio: 4);

      drawingPoints.removeRange(0, 11);
    }
  }

  void removeSticker(int index) async {
    stickers.removeAt(index);
    setState(() {});
  }
}
