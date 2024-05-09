import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ww_dev_test/animation/background_component.dart';
import 'package:ww_dev_test/animation/bottom_component.dart';
import 'package:ww_dev_test/animation/progress_component.dart';
import 'package:ww_dev_test/utils.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton.outlined(
          color: Colors.black,
          padding: const EdgeInsets.only(left: 6),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios, size: 16),
        ),
      ),
      body: Stack(
        children: [
          const BackgroundComponent(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: honebanaWidgetHeight / 2),
                const ProgressComponent(),
                Expanded(child: LayoutBuilder(builder: (context, ctr) {
                  return BottomComponent(
                    componentHeight: ctr.maxHeight,
                    componentWidth: ctr.maxWidth,
                  );
                })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
