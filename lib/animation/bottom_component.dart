import 'package:flutter/material.dart';
import 'package:ww_dev_test/animation/tooltip_component.dart';

class BottomComponent extends StatefulWidget {
  const BottomComponent({
    super.key,
    required this.componentHeight,
    required this.componentWidth,
  });

  final double componentHeight;
  final double componentWidth;

  @override
  State<BottomComponent> createState() => _BottomComponentState();
}

class _BottomComponentState extends State<BottomComponent> with SingleTickerProviderStateMixin {
  final buttonHeight = 44.0;

  late AnimationController fadeController;
  late Animation<double> animation;

  @override
  void initState() {
    animateFading();
    super.initState();
  }

  @override
  void dispose() {
    fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Stack(
        children: [
          Column(
            children: [
              const Expanded(flex: 4, child: Icon(Icons.share)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            minimumSize: Size.fromHeight(buttonHeight),
                            side: const BorderSide(color: Colors.red)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, color: Colors.red),
                            Text('Redesign', style: TextStyle(color: Colors.red)),
                          ],
                        )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          minimumSize: Size.fromHeight(buttonHeight),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Continue', style: TextStyle(color: Colors.white))),
                  ),
                ],
              ),
              const Spacer(flex: 1)
            ],
          ),
          Positioned(
            left: (widget.componentWidth - 12) / 16,
            bottom: (widget.componentHeight - buttonHeight) / 5 + 45,
            child: TooltipComponent(
              componentHeight: widget.componentHeight,
              componentWidth: widget.componentWidth,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> animateFading() async {
    fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(fadeController);

    await Future.delayed(const Duration(milliseconds: 4400));
    fadeController.forward();
  }
}
