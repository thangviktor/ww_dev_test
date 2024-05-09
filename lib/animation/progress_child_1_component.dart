import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ww_dev_test/animation/heart_component.dart';

import '../utils.dart';

class ProgressChild1Component extends StatefulWidget {
  const ProgressChild1Component({
    super.key,
    required this.heartIconOnChild2Offset,
    required this.onFoundWidgetHeight,
  });

  final Offset heartIconOnChild2Offset;
  final Function(double height) onFoundWidgetHeight;

  @override
  State<ProgressChild1Component> createState() => _ProgressChild1ComponentState();
}

class _ProgressChild1ComponentState extends State<ProgressChild1Component>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final height = (context.findRenderObject() as RenderBox).size.height;
      widget.onFoundWidgetHeight(height);
    });

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    fade = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(controller);
    animate();
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
      child: FadeTransition(
        opacity: fade,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Intro Page', style: TextStyle(fontSize: 16)),
                  Text('Design 4', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: honebanaWidgetHeight / 20),
            const Text(
              'Fantastic Progress!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
            )
                .animate()
                .then(delay: 4400.ms)
                .fadeIn(duration: 600.ms, begin: 0)
                .move(duration: 600.ms, begin: const Offset(0, 10), end: Offset.zero),
            Container(
              width: double.infinity,
              height: honebanaWidgetHeight / 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HeartComponent(
                    delay: 1500,
                    targetOffset: widget.heartIconOnChild2Offset,
                    canMoved: true,
                  ),
                  HeartComponent(
                    delay: 2000,
                    targetOffset: widget.heartIconOnChild2Offset,
                    canMoved: true,
                  ),
                  HeartComponent(
                    delay: 2500,
                    targetOffset: widget.heartIconOnChild2Offset,
                    canMoved: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> animate() async {
    await Future.delayed(const Duration(seconds: 1));
    controller.forward();
  }
}
