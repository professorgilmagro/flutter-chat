import 'package:chat_app/helpers/login.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/theme/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  ChatMessageItem({@required this.message, @required this.currentUid});

  @override
  Widget build(BuildContext context) {
    bool isMine = message.isMine(Auth().uid);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.white, spreadRadius: 3),
        ],
      ),
      child: Row(
        children: [
          isMine
              ? _getAvatar(
                  url: message.senderPhotoUrl,
                  padding: EdgeInsets.only(right: 10),
                )
              : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                _getContent(message),
                SimpleText(message.senderName,
                    color: Colors.deepPurple, size: 11),
                _getMessageInfo(message, !isMine),
              ],
            ),
          ),
          isMine
              ? Container()
              : _getAvatar(
                  url: message.senderPhotoUrl,
                  padding: EdgeInsets.only(right: 10, left: 10),
                )
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

  Widget _getContent(Message message) {
    if (message.hasImage()) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Image.network(
          message.imageUrl,
        ),
      );
    }

    return SimpleText(
      message.text,
      size: 14,
      padding: EdgeInsets.only(bottom: 10),
      color: Colors.purple,
    );
  }

  _getMessageInfo(Message message, bool alignEnd) {
    List<Widget> items = [
      Expanded(
        child: SimpleText(
          message.sentAtFormatted,
          padding: EdgeInsets.only(left: alignEnd ? 10 : 0),
          color: Colors.black54,
          size: 10,
        ),
      ),
      Icon(
        message.read ? Icons.mark_chat_read : Icons.mark_chat_unread,
        size: 20,
      ),
    ];

    return Row(
        mainAxisAlignment:
            alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: alignEnd ? items.reversed.toList() : items);
  }
}
