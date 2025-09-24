import 'package:flutter/material.dart';
import 'package:home_controll_app/utils/color_pallete.dart';


class TextApp extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final bool useFontFamily;

  const TextApp({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight = FontWeight.bold,
    this.color = AppColors.textPrimary,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.useFontFamily = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize ?? 16, // 16 é o padrão
        fontFamily: useFontFamily ? 'Roboto' : null,
        fontWeight: fontWeight,
      ),
    );
  }
}