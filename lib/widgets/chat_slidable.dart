import 'package:chat_app/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatSlidable extends StatelessWidget {
  final Widget child;
  final bool isRead;
  final bool canDelete;
  final Function onDeleteTap;
  final Function onShareTap;
  final Function onMarkTap;
  final Function onMoreTap;

  ChatSlidable({
    @required this.child,
    @required this.isRead,
    @required this.canDelete,
    this.onDeleteTap,
    this.onMarkTap,
    this.onMoreTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: child,
        actions: <Widget>[
          ChatSlideAction(
            color: Colors.black54,
            caption: isRead ? 'Não lido' : 'Lido',
            iconData:
                isRead ? Icons.mark_chat_unread_rounded : Icons.mark_chat_read,
            onTap: onMarkTap,
          ),
          ChatSlideAction(
            color: Colors.blue,
            caption: 'Share',
            iconData: Icons.share,
            onTap: onShareTap,
          ),
        ],
        secondaryActions: <Widget>[
          ChatSlideAction(
            color: Colors.black54,
            caption: 'Mais',
            iconData: Icons.more_horiz,
            onTap: onMoreTap,
          ),
          ChatSlideAction(
            color: canDelete ? Colors.red[900] : Colors.white38,
            caption: 'Delete',
            iconData: canDelete ? Icons.delete : Icons.delete_forever,
            onTap: canDelete ? onDeleteTap : null,
          ),
        ]);
  }
}

class ChatSlideAction extends StatelessWidget {
  final String caption;
  final Function onTap;
  final IconData iconData;
  final Color color;

  ChatSlideAction({this.caption, this.onTap, this.iconData, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: SlideAction(
        onTap: onTap,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 30,
            ),
            SimpleText(
              caption,
              color: Colors.white,
              size: 14,
              bold: true,
              padding: EdgeInsets.only(top: 10),
            ),
          ],
        ),
      ),
    );
  }
}
