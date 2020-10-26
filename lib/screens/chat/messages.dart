import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:chat_app/helpers/downloader.dart';
import 'package:chat_app/helpers/login.dart';
import 'package:chat_app/helpers/share.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/repository/chat.dart';
import 'package:chat_app/widgets/chat_slidable.dart';
import 'package:chat_app/widgets/image/preview.dart';
import 'package:chat_app/widgets/texts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:path/path.dart" show dirname;
import 'package:permission_handler/permission_handler.dart';

class ChatMessage extends StatelessWidget {
  final List<DocumentSnapshot> documents;
  final Function onFileDownloadStart;
  final Function onFileDownloadEnd;

  ChatMessage(
      {@required this.documents,
      this.onFileDownloadStart,
      this.onFileDownloadEnd});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: documents.length,
        reverse: true,
        itemBuilder: (context, index) {
          final data = documents[index].data;
          data['id'] = documents[index].documentID;
          Message message = Message.fromMap(data);

          return ChatMessageItem(
            message: message,
            isMine: message.isMine(Auth().uid),
            onShareTap: () async {
              final messageShare = MessageShare(
                message,
                onStartProcess: onFileDownloadStart,
                onEndProcess: onFileDownloadEnd,
              );

              messageShare.share();
            },
            onFileDownloadTap: () async {
              onFileDownloadStart();
              final localUrl = await message.attachment.localUrl;
              final downloader = Downloader(
                url: message.attachment.url,
                outputName: message.attachment.name,
                mineType: message.attachment.mineType,
                outputDir: dirname(localUrl),
              );

              if (await downloader.isDownloaded) {
                return onFileDownloadEnd(localUrl, downloader.mineType);
              }

              downloader.download().then((outputUrl) {
                if (!message.read) {
                  message.markAsRead();
                  ChatRepository(message).save();
                }
                onFileDownloadEnd(outputUrl, message.attachment.mineType);
              });
            },
          );
        });
  }
}

class ChatMessageItem extends StatelessWidget {
  final Message message;
  final Function onFileDownloadTap;
  final Function onShareTap;
  final bool isMine;

  ChatMessageItem({
    @required this.message,
    @required this.isMine,
    this.onFileDownloadTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isMine
              ? Container()
              : _getAvatar(
                  url: message.senderPhotoUrl,
                  padding: EdgeInsets.only(right: 5, bottom: 5),
                ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _getBubble(context, message),
                _getMessageInfo(message, isMine),
              ],
            ),
          ),
          isMine
              ? _getAvatar(
                  url: message.senderPhotoUrl,
                  padding: EdgeInsets.only(right: 5, left: 5),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _getAvatar({String url, EdgeInsets padding}) => Padding(
        padding: padding,
        child: CircleAvatar(
          backgroundColor: Colors.purple,
          backgroundImage: NetworkImage(url),
        ),
      );

  Widget _getBubble(context, Message message) {
    return ChatSlidable(
      isRead: message.read,
      canDelete: isMine,
      onDeleteTap: () => _delete(message),
      onMarkTap: () {
        message.read ? message.markAsUnread() : message.markAsRead();
        ChatRepository(message).save();
      },
      onShareTap: onShareTap,
      child: ChatBubble(
        clipper: ChatBubbleClipper9(
            type: isMine ? BubbleType.sendBubble : BubbleType.receiverBubble),
        alignment: isMine ? Alignment.bottomRight : Alignment.bottomLeft,
        elevation: 1,
        shadowColor: Colors.black54,
        margin: EdgeInsets.only(top: 10),
        backGroundColor: isMine ? Colors.purple : Colors.deepPurple,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            minWidth: MediaQuery.of(context).size.width * 0.125,
          ),
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              _getContent(context, message),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 6, top: 10),
                    child: Icon(
                      message.read ? Icons.done_all : Icons.done,
                      size: 18,
                    ),
                  ),
                  Expanded(
                    child: SimpleText(
                      message.readTime ?? '',
                      size: 10,
                      color: Colors.white60,
                      padding: EdgeInsets.only(top: 10),
                    ),
                  ),
                  message.hasImage()
                      ? SimpleText(
                          message.image.sizeForHuman,
                          padding: EdgeInsets.only(top: 10),
                          color: Colors.white60,
                          size: 10,
                        )
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getContent(BuildContext context, Message message) {
    if (message.hasAttach()) {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFF0E3311).withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: onFileDownloadTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SimpleText(
                      "Enviou um arquivo ${message.attachment.extension.toUpperCase()}",
                      size: 12,
                      color: Colors.amber,
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                  SimpleText(
                    message.attachment.sizeForHuman,
                    size: 10,
                    color: Colors.white54,
                    padding: EdgeInsets.only(right: 25),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    color: Colors.white,
                    size: 25,
                  ),
                  Expanded(
                    child: SimpleText(
                      message.attachment.name,
                      size: 16,
                      padding: EdgeInsets.only(left: 10),
                    ),
                  ),
                  FileIcon(
                    message.attachment.name,
                    size: 60,
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (message.hasImage()) {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => ImagePreview(
              url: message.image.url,
              label: 'Visualizar imagem',
              onDelete: () => _delete(message),
              onShare: onShareTap,
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              message.image.url,
            ),
          ),
        ),
      );
    }

    return Text(
      message.text ?? '',
      style: GoogleFonts.abel(color: Colors.white, fontSize: 14),
    );
  }

  _getMessageInfo(Message message, bool alignEnd) {
    List<Widget> items = [
      Expanded(
        child: SimpleText(
          message.sentAtFormatted,
          align: alignEnd ? TextAlign.end : TextAlign.start,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          color: Colors.white60,
          size: 9,
        ),
      )
    ];

    return Row(
        mainAxisAlignment:
            alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: alignEnd ? items.reversed.toList() : items);
  }

  _delete(Message message) async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    await ChatRepository(message).delete();
    AssetsAudioPlayer.newPlayer().open(Audio("assets/sounds/spear-throw.mp3"));
  }
}
