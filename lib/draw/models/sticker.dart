import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:ww_dev_test/utils.dart';

class Sticker {
  final String image;
  Offset offset;

  Sticker({required this.image, this.offset = const Offset(0, 0)});

  Sticker copyWith({
    String? image,
    Offset? offset,
  }) {
    return Sticker(
      image: image ?? this.image,
      offset: offset ?? this.offset,
    );
  }
}

final stickersSource = [
  Sticker(image: Asset.cat),
  Sticker(image: Asset.cloud),
  Sticker(image: Asset.corgi),
  Sticker(image: Asset.emoticon),
  Sticker(image: Asset.heart),
  Sticker(image: Asset.witch),
];
