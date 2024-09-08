import 'package:flutter/material.dart';
import 'package:splite_mate/themes/my_theme.dart';

class MyTextStyle {
  static TextStyle heading1() {
    return const TextStyle(fontWeight: FontWeight.w900, fontSize: 32.0);
  }

  static TextStyle heading2() {
    return const TextStyle(fontWeight: FontWeight.w900, fontSize: 18.0);
  }

  static TextStyle label2() {
    return const TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0);
  }

  static TextStyle elevatedButtonText() {
    return const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w900);
  }
  static TextStyle elevatedButtonText2() {
    return const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900);
  }

  static TextStyle outlinedButtonText() {
    return TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w900,
      color: MyThemes.customPrimary,
    );
  }

  static TextStyle formLabel() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15.0,
      color: Colors.black,
    );
  }

  static TextStyle lightSubHeading() {
    return const TextStyle(
        fontWeight: FontWeight.w600, fontSize: 15.0, color: Colors.black45);
  }
  static TextStyle lightSubHeading3() {
    return const TextStyle(
        fontWeight: FontWeight.w600, fontSize: 15.0, color: Colors.black54);
  }

  static TextStyle lightSubHeading2() {
    return const TextStyle(
        fontWeight: FontWeight.w600, fontSize: 13.0, color: Colors.black45);
  }
}
