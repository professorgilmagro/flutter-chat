import 'dart:io';

import 'package:chat_app/helpers/login.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/repository/chat.dart';
import 'package:chat_app/storage/file.dart';
import 'package:image_picker/image_picker.dart';

class Messenger {
  String text;
  PickedFile pickedFile;

  Messenger({this.text, this.pickedFile});

  send() async {
    Message message = _getMessageWithDefaultInformation();

    if (pickedFile != null) {
      final task = await FileStorage.upload(
        file: File(pickedFile.path),
        owner: Auth().uid,
      );
      message.imageUrl = (await task.ref.getDownloadURL()).toString();
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
