import 'package:chat_app/screens/splash/view.dart';
import 'package:chat_app/theme/style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'My Chat',
    home: Splash(),
    theme: chatAppTheme(),
  ));
}
