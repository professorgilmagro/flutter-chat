import 'package:chat_app/helpers/downloader.dart';
import 'package:chat_app/models/attachment.dart';
import 'package:chat_app/models/message.dart';
import 'package:share/share.dart';

class MessageShare {
  final Message message;
  Downloader _downloader;
  Function onStartProcess;
  Function onEndProcess;

  MessageShare(this.message, {this.onStartProcess, this.onEndProcess});

  String get subject {
    return 'Envido por ${message.senderName} de My Chat';
  }

  Downloader getDownloader(Attachment attach) {
    if (_downloader == null) {
      _downloader = Downloader(
        url: attach.url,
        mineType: attach.mineType,
        outputName: attach.name,
      );
    }

    return _downloader;
  }

  share() {
    if (message.hasImage()) {
      return _shareFile(message.image);
    }

    if (message.hasAttach()) {
      return _shareFile(message.attachment);
    }

    if (message.text != null) {
      return _shareText(message.text);
    }
  }

  _shareFile(Attachment attachment) async {
    final manager = getDownloader(attachment);
    if (!await manager.isDownloaded) {
      if (onStartProcess != null) onStartProcess();
      await manager.download();
      if (onEndProcess != null)
        onEndProcess(await manager.outputUrl, manager.mineType);
    }

    Share.shareFiles([await attachment.localUrl], subject: subject);
  }

  void _shareText(String text) {
    Share.share(text, subject: subject);
  }
}
