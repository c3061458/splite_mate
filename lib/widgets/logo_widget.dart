import 'package:flutter/material.dart';
import 'package:splite_mate/themes/my_theme.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
              color: MyThemes.customPrimary,
              width: 2.0,
            )),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Image.asset(
            "assets/icons/logo-color.png",
            height: 150.0,
          ),
        ));
  }
}
