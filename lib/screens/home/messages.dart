import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ListViewMessages(List<DocumentSnapshot> documents) {
  return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: documents.length,
      reverse: true,
      itemBuilder: (context, index) {
        Message message = Message.fromMap(documents[index].data);
        return ListItem(index, message);
      });
}

Widget ListItem(int index, Message message) {
  return Container(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white70,
      boxShadow: [
        BoxShadow(color: Colors.white, spreadRadius: 3),
      ],
    ),
    child: ListTile(
      title: Text(message.text ?? ''),
      subtitle: Text(message.sentAtFormatted),
      leading: CircleAvatar(
        backgroundColor: Colors.purple,
        backgroundImage: NetworkImage(message.senderPhotoUrl),
      ),
      trailing:
          Icon(message.read ? Icons.mark_chat_read : Icons.mark_chat_unread),
    ),
  );
}
