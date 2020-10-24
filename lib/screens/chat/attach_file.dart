import 'package:chat_app/theme/style.dart';
import 'package:chat_app/widgets/texts.dart';
import 'package:flutter/material.dart';

Future<void> showAttachFileOptions(
    {BuildContext context, Function onGalleryTap, Function onFileTap}) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                  gradient: linearGradientDefault(),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FlatButton(
                      child: SimpleText('Galeria', size: 20),
                      textColor: Colors.white,
                      onPressed: onGalleryTap,
                    ),
                    Divider(
                      color: Colors.white24,
                    ),
                    FlatButton(
                      child: SimpleText('Arquivo', size: 20),
                      textColor: Colors.white,
                      onPressed: onFileTap,
                    ),
                  ],
                ),
              );
            });
      });
}
