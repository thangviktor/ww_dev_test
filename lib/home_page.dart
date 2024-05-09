import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ww_dev_test/animation/animation_page.dart';
import 'package:ww_dev_test/draw/draw_page.dart';

import 'utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loadSize();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 4),
            const Text(
              'Mobile App Developer Test',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (context) => const DrawPage());
                      Navigator.push(context, route);
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                    child: const Text(
                      'Draw your imagination',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (context) => const AnimationPage());
                      Navigator.push(context, route);
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                    child: const Text(
                      'Watching your animation',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 6)
          ],
        ),
      ),
    );
  }

  void _loadSize() async {
    screenWidth = MediaQuery.sizeOf(context).width;
    appBarAndStatusBarHeight =
        MediaQuery.of(context).viewPadding.top + AppBar().preferredSize.height;

    final byteData = await rootBundle.load(Asset.honebana);
    final bytes = byteData.buffer.asUint8List();
    final decodedImage = await decodeImageFromList(bytes);

    honebanaWidgetHeight = screenWidth * decodedImage.height / decodedImage.width;
  }
}