import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ww_dev_test/draw/draw_frame.dart';
import 'package:ww_dev_test/draw/models/sticker.dart';

import '../utils.dart';
import 'models/pallet.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({super.key});

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  var selectedColor = pallet.first;
  var selectedWidth = 2.0;

  List<Sticker> stickers = [];

  bool requestCapture = false;
  final capturedWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        leading: IconButton.outlined(
          color: Colors.black,
          padding: const EdgeInsets.only(left: 6),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
          onPressed: Navigator
              .of(context)
              .pop,
          icon: const Icon(Icons.arrow_back_ios, size: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.outlined(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              constraints: const BoxConstraints(minWidth: 0, minHeight: 28),
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: saveFrameImage,
              icon: const Text('Save'),
            ),
          ),
        ],
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: pallet.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = pallet[index];
                              selectedWidth = 2.0;
                            });
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: pallet[index],
                              shape: BoxShape.circle,
                            ),
                            child: selectedColor == pallet[index]
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = Colors.white;
                      });
                      selectedWidth = 20;
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                          selectedColor == Colors.white ? Colors.grey.shade700 : Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: SvgPicture.asset(
                        Asset.eraser,
                        width: 20,
                        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DragTarget<String>(
              onAcceptWithDetails: (details) {
                setState(() {
                  stickers.add(Sticker(image: details.data, offset: details.offset));
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RepaintBoundary(
                    key: capturedWidgetKey,
                    child: DrawFrame(
                      selectedColor: selectedColor,
                      selectedWidth: selectedWidth,
                      stickers: stickers,
                      requestCapture: requestCapture,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: stickersSource.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return Draggable<String>(
                    data: stickersSource[index].image,
                    feedback: Image.asset(stickersSource[index].image),
                    child: Image.asset(stickersSource[index].image),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveFrameImage() async {
    showMessage(String text) => Utils.showSnackBar(context, text: text);

    setState(() {
      requestCapture = true;
    });
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      requestCapture = false;
    });

    RenderRepaintBoundary boundary = capturedWidgetKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 4);
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    var result = await ImageGallerySaver.saveImage(
      pngBytes,
      quality: 100,
    );

    log(result.toString());
    if (result['isSuccess']) {
      showMessage('Saved picture successfully!');
    } else {
      showMessage('Have errors occur!');
    }
  }
}
