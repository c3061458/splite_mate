import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splite_mate/themes/my_theme.dart';

class MyAppBar2 {

  static PreferredSizeWidget myAppBar(context, title) {
    return AppBar(
      backgroundColor: MyThemes.customPrimary,
      foregroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(CupertinoIcons.back),
      ),
    );
  }
}