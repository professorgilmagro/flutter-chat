import 'package:chat_app/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatelessWidget {
  final Function onClose;
  final Function onShare;
  final Function onDelete;
  final String url;
  final String label;

  ImagePreview({
    this.url,
    this.label,
    this.onClose,
    this.onShare,
    this.onDelete,
  });

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: HexColor("#690356"),
        title: TextSubtitle(
          label,
          alignCenter: true,
        ),
      ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(url),
          enableRotation: true,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) async {
          switch (index) {
            case 0:
              onShare();
              Navigator.pop(context);
              break;

            case 1:
              Navigator.pop(context);
              onDelete();
              break;

            case 2:
              Navigator.pop(context);
              break;
          }
        },
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Compartilhar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Remover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.close),
            label: 'Fechar',
          )
        ],
      ),
    );
  }
}
