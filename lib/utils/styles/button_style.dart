import 'package:flutter/material.dart';
import 'package:splite_mate/themes/my_theme.dart';

class MyButtonStyle {

  static ButtonStyle elevatedButton() {
    return ButtonStyle(
      minimumSize:
      WidgetStateProperty.all(const Size(double.infinity, 50)),
      backgroundColor:
      WidgetStateProperty.all(MyThemes.customPrimary),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: MyThemes.customPrimary),
        ),
      ),
    );
  }

  static ButtonStyle deleteElevatedButton() {
    return ButtonStyle(
      minimumSize:
      WidgetStateProperty.all(const Size(double.infinity, 50)),
      backgroundColor:
      WidgetStateProperty.all(Colors.red),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  static ButtonStyle outlinedButton() {
    return ButtonStyle(
      minimumSize:
      WidgetStateProperty.all(const Size(double.infinity, 50)),
      side: WidgetStateProperty.all(
          BorderSide(color: MyThemes.customPrimary)),
      overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.green.withOpacity(.1);
        }
        return Colors.transparent;
      }),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  static ButtonStyle elevatedButton2() {
    return ButtonStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0)),
      backgroundColor:
      WidgetStateProperty.all(MyThemes.customPrimary),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: MyThemes.customPrimary),
        ),
      ),
    );
  }

  static ButtonStyle elevatedButton3() {
    return ButtonStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
      backgroundColor:
      WidgetStateProperty.all(MyThemes.customPrimary),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: MyThemes.customPrimary),
        ),
      ),
    );
  }
}