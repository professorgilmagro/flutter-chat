import 'dart:io';

import 'package:chat_app/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';

class ImageAdjustment extends StatefulWidget {
  final Function onDone;
  final Function onCancel;
  File imageFile;

  ImageAdjustment({this.imageFile, this.onDone, this.onCancel});

  @override
  _ImageAdjustmentState createState() => _ImageAdjustmentState();
}

class _ImageAdjustmentState extends State<ImageAdjustment> {
  final cropKey = GlobalKey<CropState>();
  File image;

  @override
  void initState() {
    image = widget.imageFile;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextSubtitle(
          'Ajustar imagem',
          alignCenter: true,
        ),
      ),
      body: image != null
          ? Container(
              color: Colors.black,
              padding: const EdgeInsets.all(20.0),
              child: Crop(
                key: cropKey,
                image: FileImage(image),
                aspectRatio: 4.0 / 3.0,
              ),
            )
          : Container(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) async {
          switch (index) {
            case 0:
              final newFile = await ImagePicker().getImage(
                source: ImageSource.camera,
              );
              setState(() {
                image = File(newFile.path);
              });
              break;

            case 1:
              Navigator.pop(context);
              widget.onCancel != null && widget.onCancel();
              break;

            case 2:
              final croppedFile = await ImageCrop.cropImage(
                file: image,
                area: cropKey.currentState.area,
              );
              widget.onDone(croppedFile);
              Navigator.pop(context);
              break;
          }
        },
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Selecionar',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.cancel_outlined),
            label: 'Cancelar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Enviar')
        ],
      ),
    );
  }
}
