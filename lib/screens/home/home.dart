import 'package:chat_app/components/app_bar.dart';
import 'package:chat_app/components/loading.dart';
import 'package:chat_app/components/snack.dart';
import 'package:chat_app/helpers/login.dart';
import 'package:chat_app/helpers/sender.dart';
import 'package:chat_app/screens/home/messages.dart';
import 'package:chat_app/screens/home/text_area.dart';
import 'package:chat_app/storage/db.dart';
import 'package:chat_app/theme/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _stateWaiting = [ConnectionState.waiting, ConnectionState.none];
  bool _loginFails = false;
  String _userName;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      Login().user = user;
      setState(() => {_userName = user.displayName});
    });

    Login().auth().then((auth) {
      if (auth.isNotLogged()) {
        setState(() {
          _loginFails = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        title: "Olá ${_userName ?? 'usuário'}",
        onLeaveTap: () {},
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradientDefault()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: DB.getCollection().snapshots(),
                builder: (context, snapshot) {
                  if (_loginFails) {
                    SnackMessage(context,
                            'Não foi possível fazer o login. Tente novamente mais tarde!')
                        .show();
                  }
                  if (_stateWaiting.contains(snapshot.connectionState)) {
                    return Loading(text: 'Obtendo dados...').build();
                  }

                  return ListViewMessages(snapshot.data.documents);
                },
              ),
            ),
            TextComposer(
              onCameraTap: (Future<PickedFile> file) {
                file.then((pickedFile) {
                  Messenger(pickedFile: pickedFile).send();
                });
              },
              onTextSubmitted: (text) => Messenger(text: text).send(),
            ),
          ],
        ),
      ),
    );
  }
}
