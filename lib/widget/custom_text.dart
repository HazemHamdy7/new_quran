// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  CustomText({
    super.key,
    TextAlign textAlign = TextAlign.center,
    required this.text,
    required int fontSize,
    required FontWeight fontWeight,
    required Color color,
  });
  final String text;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: GoogleFonts.amiri(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ));
  }
}
