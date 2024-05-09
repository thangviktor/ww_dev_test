import 'package:flutter/material.dart';
import 'package:ww_dev_test/animation/progress_child_1_component.dart';
import 'package:ww_dev_test/animation/progress_child_2_component.dart';

class ProgressComponent extends StatefulWidget {
  const ProgressComponent({super.key});

  @override
  State<ProgressComponent> createState() => _ProgressComponentState();
}

class _ProgressComponentState extends State<ProgressComponent> {
  double child1Height = 400;

  Offset heartIconOnChild2Offset = const Offset(250, 600);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: child1Height + 16),
            ProgressChild2Component(
              onFoundHeartIconPosition: (Offset offset) {
                setState(() {
                  heartIconOnChild2Offset = offset;
                });
              },
            ),
          ],
        ),
        ProgressChild1Component(
          heartIconOnChild2Offset: heartIconOnChild2Offset,
          onFoundWidgetHeight: (double height) {
            setState(() {
              child1Height = height;
            });
          },
        ),
      ],
    );
  }
}
