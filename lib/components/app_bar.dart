import 'package:chat_app/helpers/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

AppBar chatAppBar({@required title, Function onLeaveTap}) =>
    customAppBar(title: title, actions: [leaveAction(onTapped: onLeaveTap)]);

Widget leaveAction({Function onTapped}) {
  return Padding(
    padding: EdgeInsets.only(right: 10),
    child: Auth().isLogged()
        ? IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.amberAccent,
              size: 30,
            ),
            onPressed: onTapped,
          )
        : Container(),
  );
}

AppBar customAppBar({@required title, List<Widget> actions}) => AppBar(
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
      shadowColor: Colors.purple,
      elevation: 1,
      leading: Icon(
        Icons.chat_bubble_outline,
        color: Colors.amber,
        size: 36,
      ),
      backgroundColor: HexColor('#690356'),
      actions: actions,
    );

FloatingActionButton floatingAddButtonAction({Function onPressed}) =>
    FloatingActionButton(
      onPressed: onPressed,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
      elevation: 0.5,
    );
