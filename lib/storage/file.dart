import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileStorage {
  static const String DIR = 'messages';

  static Future<StorageTaskSnapshot> upload({
    @required File file,
    @required String owner,
  }) async {
    final task = FirebaseStorage.instance
        .ref()
        .child(DIR)
        .child(owner)
        .child(UniqueKey().toString())
        .putFile(file);

    return await task.onComplete;
  }
}
