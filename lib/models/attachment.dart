import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path_provider/path_provider.dart';

class Attachment {
  String url;
  String mineType;
  String name;
  int size;

  Attachment({this.url, this.mineType, this.name, this.size});

  String toString() {
    return toMap().toString();
  }

  Attachment.fromMap(Map<String, dynamic> data) {
    if (data != null) {
      name = data['name'] ?? null;
      url = data['url'] ?? null;
      size = data['size'] ?? null;
      mineType = data['mineType'] ?? null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'size': size,
      'mineType': mineType,
    };
  }

  Attachment.fromFromUrl(String url) {
    mineType = mime(url);
    name = url.split("/").last;
  }

  String get extension {
    return extensionFromMime(mineType);
  }

  String get sizeForHuman {
    return filesize(size ?? 0, 2);
  }

  Future<String> get localUrl async {
    Directory dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$name';
  }

  Future<bool> isDownloaded() async {
    return File(await localUrl).existsSync();
  }
}
