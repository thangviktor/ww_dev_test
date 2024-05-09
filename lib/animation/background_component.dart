import 'package:flutter/material.dart';

import '../utils.dart';

class BackgroundComponent extends StatefulWidget {
  const BackgroundComponent({super.key});

  @override
  State<BackgroundComponent> createState() => _BackgroundComponentState();
}

class _BackgroundComponentState extends State<BackgroundComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(controller);
    animateFading();
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
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Image.asset(Asset.honebana),
          ),
          Container(
            height: honebanaWidgetHeight + 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.4),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.7],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> animateFading() async {
    await Future.delayed(const Duration(milliseconds: 300));
    controller.forward();

  }
}
