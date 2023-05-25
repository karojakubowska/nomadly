import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primary = const Color(0xFF687daf);

class Styles {
  static Color primaryColor = primary;
  static Color textColor = const Color(0xFF3b3b3b);
  static Color greyColor = const Color.fromARGB(255, 173, 173, 173);
  static Color whiteColor = const Color.fromARGB(255, 255, 255, 255);
  static Color pinColor = const Color.fromARGB(255, 49, 134, 252);
  static Color backgroundColor = const Color(0xFFeeedf2);
  static TextStyle textStyle =
      TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle = GoogleFonts.roboto(
    fontSize: 45,
    fontWeight: FontWeight.w700,
  );
  static TextStyle headLineStyle2 = GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(255, 173, 173, 173));
  static TextStyle headLineStyle3 =
      GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w700);
  static TextStyle headLineStyle4 = GoogleFonts.roboto(
      fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle viewAllStyle =
      GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w500);
  // ignore: non_constant_identifier_names
  static TextStyle houseNameStyle = GoogleFonts.roboto(
      fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle popularNameStyle = GoogleFonts.roboto(
      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle popularDateStyle = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: const Color.fromARGB(255, 173, 173, 173));
  static TextStyle bookingDetailsStyle = GoogleFonts.roboto(
      fontSize: 18, fontWeight: FontWeight.w700, color: const Color.fromARGB(255, 180, 180, 180));
  static Divider divider = Divider(
    color: Styles.greyColor,
    height: 50,
    thickness: 1,
    indent: 20,
    endIndent: 20,
  );
}
