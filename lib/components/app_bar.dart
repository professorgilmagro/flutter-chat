import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar CustomAppBar({@required title, List<Widget> actions}) => AppBar(
      title: Text(
        title,
        style: GoogleFonts.acme(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 26,
          letterSpacing: 1,
        ),
      ),
      toolbarHeight: 80,
      shadowColor: Colors.red,
      elevation: 1,
      leading: Image.asset(
        'assets/images/logo.png',
        height: 30,
      ),
      backgroundColor: Colors.red[900],
      actions: actions,
    );

FloatingActionButton FloatingAddButtonAction({Function onPressed}) => FloatingActionButton(
  onPressed: onPressed,
  child: Icon(Icons.add, color: Colors.white,),
  backgroundColor: Colors.red,
  elevation: 0.5,
);