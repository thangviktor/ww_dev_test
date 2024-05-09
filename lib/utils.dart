import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(
    BuildContext context, {
    required String text,
    Color? color,
    int? duration,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
          duration: Duration(milliseconds: duration ?? 1000),
        ),
      );
}

late double screenWidth;
late double appBarAndStatusBarHeight;
double honebanaWidgetHeight = 400;

class Asset {
  static const String cat = 'assets/cat.png';
  static const String cloud = 'assets/cloud.png';
  static const String corgi = 'assets/corgi.png';
  static const String emoticon = 'assets/emoticon.png';
  static const String gold = 'assets/gold.png';
  static const String heart = 'assets/heart.png';
  static const String witch = 'assets/witch.png';
  static const String eraser = 'assets/eraser.svg';
  static const String honebana = 'assets/honebana.jpeg';
}