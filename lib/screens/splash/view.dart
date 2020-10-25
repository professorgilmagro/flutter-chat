import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/screens/chat/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }
}

Widget _introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 7,
        gradientBackground: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [HexColor("#690356"), HexColor("#8E0C76")],
        ),
        navigateAfterSeconds: Home(),
        loaderColor: Colors.transparent,
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                Icons.chat_bubble_outline,
                color: Colors.orange,
                size: 120,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 20.0, height: 50.0),
                Text(
                  "For ",
                  style: GoogleFonts.aclonica(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      color: Colors.white),
                ),
                RotateAnimatedTextKit(
                    text: ["ME", "YOU", "ALL"],
                    textStyle: GoogleFonts.aclonica(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        color: Colors.amber),
                    textAlign: TextAlign.start),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
