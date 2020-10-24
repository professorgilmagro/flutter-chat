import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleText extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final double size;
  final TextAlign align;
  final Color color;
  final bool bold;

  SimpleText(
    this.text, {
    this.padding,
    this.color,
    this.align,
    this.bold,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        textAlign: align ?? TextAlign.left,
        style: GoogleFonts.abel(
            fontWeight: bold ?? false ? FontWeight.bold : FontWeight.normal,
            fontSize: size,
            color: color ?? Colors.white,
            decoration: TextDecoration.none),
      ),
    );
  }
}

class TextTitle extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final bool alignCenter;
  TextTitle(this.text, {this.padding, this.alignCenter});

  @override
  Widget build(BuildContext context) {
    final align = alignCenter ? TextAlign.center : null;
    return SimpleText(text,
        size: 30, padding: padding, align: align, bold: true);
  }
}

class TextSubtitle extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final bool alignCenter;
  final Color color;

  TextSubtitle(this.text, {this.color, this.padding, this.alignCenter});

  @override
  Widget build(BuildContext context) {
    final align = alignCenter ? TextAlign.center : null;
    return SimpleText(text, size: 20, color: color, align: align, bold: true);
  }
}
