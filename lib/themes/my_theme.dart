import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: customPrimary,
      fontFamily: GoogleFonts.aBeeZee().fontFamily,
    );
  }

  static Color customPrimary = const Color(0xff0074d9);
  static Color customAccent = const Color(0xff2CAC69);
  static Color customBackground = const Color(0xffE5F5ED);
}