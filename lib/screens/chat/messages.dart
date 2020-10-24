import 'dart:io';

import 'package:chat_app/helpers/login.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/repository/chat.dart';
import 'package:chat_app/widgets/texts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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
          Message message = Message.fromMap(documents[index].data);
          message.id = documents[index].documentID;
          return ChatMessageItem(
            message: message,
            isMine: message.isMine(Auth().uid),
            onFileDownloadTap: () async {
              onFileDownloadStart();
              var status = await Permission.storage.status;
              if (!status.isGranted) {
                await Permission.storage.request();
              }

              final attach = message.attachment;
              final localUrl = await attach.localUrl;
              final file = File(localUrl);
              if (message.read && await file.exists()) {
                return onFileDownloadEnd(localUrl, message.attachment.mineType);
              }

              http.Client client = http.Client();
              var req = await client.get(Uri.parse(attach.url));
              var bytes = req.bodyBytes;

              await file.writeAsBytes(bytes);

              message.markAsRead();
              ChatRepository(message).save();

              onFileDownloadEnd(localUrl, message.attachment.mineType);
            },
          );
        });
  }
}

class ChatMessageItem extends StatelessWidget {
  final Message message;
  final Function onFileDownloadTap;
  final bool isMine;

  ChatMessageItem({
    @required this.message,
    @required this.isMine,
    this.onFileDownloadTap,
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

  Widget _getBubble(context, message) {
    return ChatBubble(
      clipper: ChatBubbleClipper9(
          type: isMine ? BubbleType.sendBubble : BubbleType.receiverBubble),
      alignment: isMine ? Alignment.bottomRight : Alignment.bottomLeft,
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
                SimpleText(message.readTime ?? '',
                    size: 10,
                    color: Colors.white60,
                    padding: EdgeInsets.only(top: 10))
              ],
            )
          ],
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
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            message.imageUrl,
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
}
