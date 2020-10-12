import 'package:flutter/material.dart';

class SnackMessage {
  BuildContext context;
  String description;
  SnackBarAction barAction;
  String textPrefix;
  String textSuffix;
  bool undoAction = false;
  int seconds;
  GlobalKey<ScaffoldState> scaffoldKey;
  SnackMessage(this.scaffoldKey, this.description,
      {this.barAction, this.seconds});

  SnackBar get snack {
    return SnackBar(
        duration: Duration(seconds: seconds ?? 4),
        content: content,
        backgroundColor: Colors.deepPurple,
        action: barAction);
  }

  Widget get content {
    if (undoAction) {
      return undoText;
    }

    return Text(description, style: TextStyle(color: Colors.white));
  }

  void showUndoMessage(Function onUndoPressed,
      {String label, String textPrefix, String textSuffix}) {
    undoAction = true;
    barAction = barAction ??
        SnackBarAction(
          label: label ?? "Desfazer",
          onPressed: onUndoPressed,
        );

    this.show();
  }

  Widget get undoText {
    return RichText(
      text: TextSpan(
        text: '${textPrefix ?? "Tarefa"} ',
        style: TextStyle(color: Colors.white),
        children: <TextSpan>[
          TextSpan(
            text: description,
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.amber),
          ),
          TextSpan(text: ' ${textSuffix ?? "removida!"}'),
        ],
      ),
    );
  }

  show() {
    return scaffoldKey.currentState.showSnackBar(snack);
  }
}
