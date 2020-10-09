import 'package:chat_app/components/app_bar.dart';
import 'package:chat_app/screens/home/text_area.dart';
import 'package:chat_app/theme/style.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        title: "Olá Fulano",
        onLeaveTap: () {},
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradientDefault()),
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white10,
              ),
            ),
            TextComposer(),
          ],
        ),
      ),
    );
  }
}
