import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData ChatAppTheme() => ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.deepPurple,
      accentColor: Colors.purple,
      hintColor: Colors.yellow,
      iconTheme: IconThemeData(
        color: Colors.amber,
      ),
      fontFamily: GoogleFonts.aladin().fontFamily,
    );

LinearGradient LinearGradientDefault() => LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [HexColor("#690356"), HexColor("#8E0C76")],
    );
