import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../utils.dart';

class HeartComponent extends StatefulWidget {
  const HeartComponent({
    super.key,
    required this.targetOffset,
    required this.delay,
    required this.canMoved,
  });

  final Offset targetOffset;
  final int delay;
  final bool canMoved;

  @override
  State<HeartComponent> createState() => _HeartComponentState();
}

class _HeartComponentState extends State<HeartComponent> {
  final heartIconKey = GlobalKey();

  Offset originalOffset = const Offset(0, 0);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calOriginalOffset();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.canMoved
          ? Image.asset(
              Asset.heart,
              width: 51.2,
            )
              .animate()
              .fade(delay: (widget.delay + 1200).ms, begin: 0, end: 0.3, curve: Curves.easeIn)
              .then(delay: 3000.ms)
              .fade(begin: 1, end: 10)
          : Image.asset(
              Asset.heart,
              width: 51.2,
              opacity: const AlwaysStoppedAnimation(0.3),
            ),
      Visibility(
        key: heartIconKey,
        visible: widget.canMoved,
        child: Image.asset(
          Asset.heart,
          width: 51.2,
        )
            .animate()
            .then(delay: widget.delay.ms)
            // scale down then back to original
            .scale(
                duration: 100.ms,
                begin: const Offset(1, 1),
                end: const Offset(0.75, 0.75),
                alignment: Alignment.center)
            .then()
            .scale(
                duration: 100.ms,
                begin: const Offset(1, 1),
                end: const Offset(1 / 0.75, 1 / 0.75),
                alignment: Alignment.center)
            .then(delay: 100.ms)
            // scale up and then back to original, fill color
            .scale(
                duration: 100.ms,
                begin: const Offset(1, 1),
                end: const Offset(1.25, 1.25),
                alignment: Alignment.center)
            .then()
            .scale(
                duration: 100.ms,
                begin: const Offset(1, 1),
                end: const Offset(1 / 1.25, 1 / 1.25),
                alignment: Alignment.center)
            .fadeIn(duration: 100.ms, begin: 0.3)
            .then(delay: 700.ms)
            // scale up and rotate, prepare for moving
            .scale(
                duration: 500.ms,
                begin: const Offset(1, 1),
                end: const Offset(1.25, 1.25),
                alignment: Alignment.topLeft)
            .rotate(duration: 500.ms, begin: 0, end: -0.05, alignment: Alignment.topLeft)
            .then(delay: 200.ms)
            // move to target while scale down to equal the target and rotate to original angle
            .scale(
                duration: 500.ms,
                begin: const Offset(1, 1),
                end: const Offset(0.25, 0.25),
                alignment: Alignment.topLeft)
            .rotate(duration: 500.ms, begin: 0, end: 0.05, alignment: Alignment.topLeft)
            .move(
              duration: 500.ms,
              begin: const Offset(0, 0),
              end: Offset(widget.targetOffset.dx - originalOffset.dx,
                  widget.targetOffset.dy - originalOffset.dy),
            ),
      ),
    ]);
  }

  Future<void> calOriginalOffset() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final RenderBox renderBox = heartIconKey.currentContext!.findRenderObject() as RenderBox;
    originalOffset = renderBox.localToGlobal(Offset.zero);
  }
}
