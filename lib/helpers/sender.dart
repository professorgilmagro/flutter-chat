import 'dart:io';

import 'package:chat_app/helpers/login.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/repository/chat.dart';
import 'package:chat_app/storage/file.dart';

class Messenger {
  String text;
  String filePath;
  bool isImage;

  Messenger({this.text, this.filePath, this.isImage});

  send() async {
    Message message = _getMessageWithDefaultInformation();

    if (filePath != null) {
      final file = File(filePath);
      final task = await FileStorage.upload(
        file: file,
        owner: Auth().uid,
      );

      String fileUrl = (await task.ref.getDownloadURL()).toString();

      int fileSize = await file.length();
      message.setFileInfo(
        downloadUrl: fileUrl,
        attach: !isImage,
        localUrl: filePath,
        size: fileSize,
      );
    }

    if (text != null) {
      message.text = text;
    }

    ChatRepository(message).push();
  }

  Message _getMessageWithDefaultInformation() {
    return Message(
      uid: Auth().uid,
      senderPhotoUrl: Auth().avatarUrl,
      senderName: Auth().name,
      sendAt: DateTime.now(),
    );
  }
}
