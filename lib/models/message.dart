import 'package:chat_app/models/attachment.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Message {
  static const PRETTY_DATE_FORMAT = 'E, d MMMM y H:m';

  String id;
  String uid;
  String text;
  Attachment image;
  String senderPhotoUrl;
  String senderName;
  DateTime readAt;
  DateTime sendAt;
  bool read;
  Attachment attachment;

  Message({
    this.text,
    this.image,
    this.senderName,
    this.senderPhotoUrl,
    this.uid,
    this.read,
    this.sendAt,
    this.attachment,
  });

  String toString() {
    return toMap().toString();
  }

  String get sentAtFormatted {
    _initDateFormatter();
    return sendAt != null
        ? DateFormat(PRETTY_DATE_FORMAT).format(sendAt)
        : null;
  }

  String get readAtFormatted {
    _initDateFormatter();
    return readAt != null
        ? DateFormat(PRETTY_DATE_FORMAT).format(readAt)
        : null;
  }

  String get readTime {
    _initDateFormatter();
    return readAt != null ? DateFormat('H:m').format(readAt) : null;
  }

  bool hasImage() {
    return image != null && image.url != null;
  }

  bool hasAttach() {
    return attachment != null && attachment.url != null;
  }

  bool isMine(String uuid) {
    return this.uid == uuid;
  }

  void setFileInfo(
      {@required String downloadUrl,
      @required String localUrl,
      @required bool attach,
      int size}) {
    final fileInfo = Attachment.fromFromUrl(localUrl);
    fileInfo.url = downloadUrl;
    fileInfo.size = size;

    if (attach) {
      this.attachment = fileInfo;
    } else {
      this.image = fileInfo;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'read': read ?? false,
      'readAt': readAt,
      'sendAt': sendAt,
      'text': text,
      'image': hasImage() ? image.toMap() : null,
      'attachment': hasAttach() ? attachment.toMap() : null,
      'sender': {
        'name': senderName,
        'photoUrl': senderPhotoUrl,
      }
    };
  }

  Message.fromMap(Map<String, dynamic> data) {
    print(data);
    id = data['id'] ?? null;
    uid = data['uid'] ?? null;
    read = data['read'] ?? false;
    readAt = data['readAt'] != null ? data['readAt'].toDate() : null;
    sendAt = data['sendAt'].toDate();
    text = data['text'] ?? null;
    attachment = Attachment.fromMap(data['attachment'] ?? null);
    senderName = data['sender']['name'] ?? null;
    senderPhotoUrl = data['sender']['photoUrl'] ?? null;
    _fillImage(data);
  }

  void _fillImage(Map<String, dynamic> data) {
    if (data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty) {
      image = Attachment.fromFromUrl(data['imageUrl']);
      image.url = data['imageUrl'];
      image.name = '$id.jpg';
      return;
    }

    image = Attachment.fromMap(data['image'] ?? null);
  }

  markAsRead() {
    readAt = DateTime.now();
    read = true;
  }

  markAsUnread() {
    readAt = null;
    read = false;
  }

  _initDateFormatter() {
    Intl.defaultLocale = 'pt_BR';
    initializeDateFormatting();
  }
}
