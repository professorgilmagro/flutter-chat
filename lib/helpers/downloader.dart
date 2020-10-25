import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Downloader {
  final String url;
  final String mineType;
  String outputName;
  String outputDir;
  File _file;

  Downloader(
      {@required this.url, this.outputName, this.outputDir, this.mineType});

  Future<String> get outputUrl async {
    if (outputDir == null) {
      outputDir = (await getApplicationDocumentsDirectory()).path;
    }

    if (outputName == null) {
      outputName = url.split("/").last;
    }

    return '$outputDir/$outputName';
  }

  Future<File> get file async {
    if (_file != null) {
      return _file;
    }

    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    _file = File(await outputUrl);
    return _file;
  }

  Future<bool> get isDownloaded async {
    return (await file).existsSync();
  }

  Future<String> download() async {
    if (await isDownloaded) {
      return await outputUrl;
    }

    http.Client client = http.Client();
    final req = await client.get(Uri.parse(url));
    final bytes = req.bodyBytes;
    await (await file).writeAsBytes(bytes);
    return outputUrl;
  }
}
