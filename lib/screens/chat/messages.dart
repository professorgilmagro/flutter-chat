import 'package:chat_app/helpers/login.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/theme/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  ChatMessage({@required this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: documents.length,
        reverse: true,
        itemBuilder: (context, index) {
          Message message = Message.fromMap(documents[index].data);
          return ChatMessageItem(
            message: message,
            currentUid: Auth().uid,
          );
        });
  }
}

class ChatMessageItem extends StatelessWidget {
  final Message message;
  final String currentUid;
  bool _isMine;

  ChatMessageItem({@required this.message, @required this.currentUid});

  @override
  Widget build(BuildContext context) {
    _isMine = message.isMine(Auth().uid);
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _isMine
              ? Container()
              : _getAvatar(
                  url: message.senderPhotoUrl,
                  padding: EdgeInsets.only(right: 5, bottom: 5),
                ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:
                  _isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _getContent(context, message),
                _getMessageInfo(message, _isMine),
              ],
            ),
          ),
          _isMine
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

  Widget _getContent(BuildContext context, Message message) {
    Widget display = Text(
      message.text ?? '',
      style: GoogleFonts.abel(color: Colors.white),
    );

    if (message.hasImage()) {
      display = Container(
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

    return ChatBubble(
      clipper: ChatBubbleClipper9(
          nipSize: 6,
          type: _isMine ? BubbleType.sendBubble : BubbleType.receiverBubble),
      alignment: _isMine ? Alignment.bottomRight : Alignment.bottomLeft,
      margin: EdgeInsets.only(top: 10),
      backGroundColor: _isMine ? Colors.amber[800] : Colors.purple,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minWidth: MediaQuery.of(context).size.width * 0.125,
        ),
        child: Column(
          crossAxisAlignment:
              _isMine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            display,
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(
                message.read ? Icons.done_all : Icons.done,
                size: 18,
              ),
            ),
          ],
        ),
      ),
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
