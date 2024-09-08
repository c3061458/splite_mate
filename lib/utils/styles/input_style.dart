import 'package:flutter/material.dart';
import 'package:splite_mate/themes/my_theme.dart';

class MyInputStyle {
  static InputDecoration textFormField() {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: MyThemes.customPrimary, width: 2.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: MyThemes.customPrimary, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: MyThemes.customPrimary, width: 3.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red, width: 3.0),
      ),
    );
  }

  static InputDecoration textFormField2() {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: MyThemes.customAccent, width: 2.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: MyThemes.customAccent, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: MyThemes.customAccent, width: 3.0),
      ),
    );
  }
}
