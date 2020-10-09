import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.photo_camera_outlined,
            color: Colors.amber,
          ),
          onPressed: () {},
        ),
        Expanded(
          child: TextFormField(
            style: GoogleFonts.asap(color: Colors.white, fontSize: 18),
            cursorColor: Colors.yellow,
            decoration: InputDecoration.collapsed(
              hintText: 'Enviar mensagem',
              hoverColor: Colors.white,
              hintStyle: GoogleFonts.asap(color: Colors.white, fontSize: 18),
            ),
            onChanged: (text) {
              setState(() {
                _isComposing = text.isNotEmpty;
              });
            },
            onFieldSubmitted: (text) {},
          ),
        ),
        IconButton(
            disabledColor: Colors.white38,
            icon: Icon(
              Icons.send,
              color: Colors.yellow,
            ),
            onPressed: _isComposing ? () {} : null)
      ],
    );
  }
}
