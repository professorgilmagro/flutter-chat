import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Message {
  static const PRETTY_DATE_FORMAT = 'E, d MMMM y H:m';

  String id;
  String uid;
  String text;
  String imageUrl;
  String senderPhotoUrl;
  String senderName;
  DateTime readAt;
  DateTime sendAt;
  bool read;

  Message({
    this.text,
    this.imageUrl,
    this.senderName,
    this.senderPhotoUrl,
    this.uid,
    this.read,
    this.sendAt,
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

  bool hasImage() {
    return imageUrl != null;
  }

  bool isMine(String uuid) {
    return this.uid == uuid;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'read': read ?? false,
      'readAt': readAt,
      'sendAt': sendAt,
      'text': text,
      'imageUrl': imageUrl,
      'sender': {
        'name': senderName,
        'photoUrl': senderPhotoUrl,
      }
    };
  }

  Message.fromMap(Map<String, dynamic> data) {
    uid = data['uid'] ?? null;
    read = data['read'] ?? false;
    readAt = data['readAt'] != null ? data['readAt'].toDate() : null;
    sendAt = data['sendAt'].toDate();
    text = data['text'] ?? null;
    imageUrl = data['imageUrl'] ?? null;
    senderName = data['sender']['name'] ?? null;
    senderPhotoUrl = data['sender']['photoUrl'] ?? null;
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
