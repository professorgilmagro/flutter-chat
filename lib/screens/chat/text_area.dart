import 'package:chat_app/screens/chat/attach_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  final Function(String) onTextSubmitted;
  final Function(Future<PickedFile>) onCameraTap;
  final Function(String, bool) onFileAttach;

  TextComposer({this.onTextSubmitted, this.onCameraTap, this.onFileAttach});

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#690356"),
      padding: EdgeInsets.all(6),
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
            child: Container(
              height: 40,
              child: TextField(
                controller: _controller,
                style: GoogleFonts.abel(color: Colors.white, fontSize: 18),
                cursorColor: Colors.yellow,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  hintText: 'Enviar mensagem',
                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                  hoverColor: Colors.purpleAccent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.grey, width: 0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintStyle:
                      GoogleFonts.asap(color: Colors.white54, fontSize: 16),
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
          ),
          IconButton(
            disabledColor: Colors.amber,
            icon: Icon(_isComposing ? Icons.send : Icons.attach_file),
            onPressed: () {
              onSendMessage(showOptions: !_isComposing);
            },
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

  onSendMessage({@required bool showOptions}) {
    if (_isComposing) {
      widget.onTextSubmitted(_controller.text);
      return _reset();
    }

    if (!showOptions) {
      return;
    }

    showAttachFileOptions(
      context: context,
      onGalleryTap: () async {
        final picker =
            await ImagePicker().getImage(source: ImageSource.gallery);
        if (picker != null) {
          widget.onFileAttach(picker.path, true);
        }
        Navigator.pop(context);
      },
      onFileTap: () async {
        FilePickerResult result = await FilePicker.platform.pickFiles();
        if (result != null) {
          widget.onFileAttach(result.files.single.path, false);
        }
        Navigator.pop(context);
      },
    );
  }
}
