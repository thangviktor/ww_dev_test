import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ww_dev_test/animation/progress_indicator_component.dart';

import '../utils.dart';

class ProgressChild2Component extends StatefulWidget {
  const ProgressChild2Component({super.key, required this.onFoundHeartIconPosition});

  final Function(Offset offset) onFoundHeartIconPosition;

  @override
  State<ProgressChild2Component> createState() => _ProgressChild2ComponentState();
}

class _ProgressChild2ComponentState extends State<ProgressChild2Component>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  final heartIconKey = GlobalKey();

  int numOfHeart = 2;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(
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
    return FadeTransition(
      opacity: animation,
      child: AnimatedBuilder(
        animation: controller.view,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(controller.value, controller.value * -10),
            child: child,
          );
        },
        child: Stack(children: [
          Container(
            width: double.infinity,
            height: honebanaWidgetHeight / 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
          )
              .animate()
              .then(delay: 3800.ms)
              .scale(duration: 50.ms, begin: const Offset(1, 1), end: const Offset(0.95, 0.95))
              .tint(duration: 50.ms, color: Colors.red.shade50, curve: Curves.linear)
              .then()
              .scale(
                  duration: 50.ms, begin: const Offset(1, 1), end: const Offset(1 / 0.95, 1 / 0.95))
              .tint(duration: 50.ms, color: Colors.grey.shade100)
              .then(delay: 400.ms)
              .scale(duration: 50.ms, begin: const Offset(1, 1), end: const Offset(0.95, 0.95))
              .tint(duration: 50.ms, color: Colors.red.shade50, curve: Curves.linear)
              .then()
              .scale(
                  duration: 50.ms, begin: const Offset(1, 1), end: const Offset(1 / 0.95, 1 / 0.95))
              .tint(duration: 50.ms, color: Colors.grey.shade100),
          Container(
            width: double.infinity,
            height: honebanaWidgetHeight / 6,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('NEXT MILESTONE')),
                          Row(
                            children: [
                              Image.asset(key: heartIconKey, Asset.heart, width: 16),
                              const SizedBox(width: 4),
                              Text('$numOfHeart/10')
                            ],
                          )
                        ],
                      ),
                      ProgressIndicatorComponent(
                        value: numOfHeart / 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Image.asset(Asset.gold),
              ],
            ),
          )
              .animate()
              .then(delay: 3800.ms)
              .scale(duration: 50.ms, begin: const Offset(1, 1), end: const Offset(0.95, 0.95))
              .then()
              .scale(
                  duration: 50.ms, begin: const Offset(1, 1), end: const Offset(1 / 0.95, 1 / 0.95))
              .then(delay: 400.ms)
              .scale(duration: 50.ms, begin: const Offset(1, 1), end: const Offset(0.95, 0.95))
              .then()
              .scale(
                  duration: 50.ms,
                  begin: const Offset(1, 1),
                  end: const Offset(1 / 0.95, 1 / 0.95)),
        ]),
      ),
    );
  }

  Future<void> animate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    await controller.forward();

    final RenderBox renderBox = heartIconKey.currentContext!.findRenderObject() as RenderBox;
    widget.onFoundHeartIconPosition(renderBox.localToGlobal(Offset.zero));

    await Future.delayed(const Duration(milliseconds: 1800));
    setState(() {
      numOfHeart += 1;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      numOfHeart += 1;
    });
  }
}
