import 'package:flutter/material.dart';

class TooltipComponent extends StatefulWidget {
  const TooltipComponent({super.key, required this.componentHeight, required this.componentWidth});

  final double componentHeight;
  final double componentWidth;


  @override
  State<TooltipComponent> createState() => _TooltipComponentState();
}

class _TooltipComponentState extends State<TooltipComponent> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.view,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(controller.value, controller.value * -10),
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: (widget.componentWidth - 12) * 3 / 8,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 6), // changes position of shadow
                ),
              ],
            ),
            child: const Text('Can you Perfect your Design?', textAlign: TextAlign.center),
          ),
          Positioned(
            child: CustomPaint(
              painter: TrianglePainter(),
              child: SizedBox(width: (widget.componentWidth - 12) / 16, height: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white;
    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x / 2, y)
      ..lineTo(x, 0)
      ..lineTo(0, 0);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return false;
  }
}
