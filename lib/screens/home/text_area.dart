import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  final Function(String) onTextSubmitted;
  final Function(Future<PickedFile>) onCameraTap;

  TextComposer({this.onTextSubmitted, this.onCameraTap});

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.photo_camera_outlined,
            ),
            onPressed: () async {
              final file = ImagePicker().getImage(source: ImageSource.camera);
              widget.onCameraTap(file);
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
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
              onSubmitted: (text) {
                widget.onTextSubmitted(text);
                _reset();
              },
            ),
          ),
          IconButton(
            disabledColor: Colors.white70,
            icon: Icon(Icons.send),
            onPressed: _isComposing ? onSendMessage : null,
          )
        ],
      ),
    );
  }

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  onSendMessage() {
    widget.onTextSubmitted(_controller.text);
    _reset();
  }
}
