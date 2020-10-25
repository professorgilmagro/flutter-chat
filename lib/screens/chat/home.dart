import 'package:chat_app/components/app_bar.dart';
import 'package:chat_app/components/loading.dart';
import 'package:chat_app/components/snack.dart';
import 'package:chat_app/helpers/login.dart';
import 'package:chat_app/helpers/sender.dart';
import 'package:chat_app/screens/chat/messages.dart';
import 'package:chat_app/screens/chat/text_area.dart';
import 'package:chat_app/storage/db.dart';
import 'package:chat_app/theme/style.dart';
import 'package:chat_app/widgets/texts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _stateWaiting = [ConnectionState.waiting, ConnectionState.none];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isUploading = false;

  String _title = '';

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        Auth().user = user;
        _title = Auth().isLogged() ? "Olá ${Auth().name}" : '';
      });
    });

    Auth().signIn().then((auth) {
      if (auth.isLoginFails) {
        setState(() {
          SnackMessage(_scaffoldKey,
                  'Não foi possível fazer o login. Tente novamente mais tarde!')
              .show();
        });
      }
    });
  }

  showFileLoading(bool value) {
    setState(() {
      _isUploading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: chatAppBar(
        title: _title,
        onLeaveTap: () {
          SnackMessage(_scaffoldKey, 'Logout efetuado com sucesso!').show();
          setState(() {
            Auth().signOut();
            _title = 'Login necessário';
          });
        },
      ),
      body: Container(
        decoration: BoxDecoration(gradient: linearGradientDefault()),
        child: (Auth().isLoginFails || Auth().isNotLogged())
            ? _notLoggedScreen()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: DB.getCollection().orderBy('sendAt').snapshots(),
                      builder: (context, snapshot) {
                        if (_stateWaiting.contains(snapshot.connectionState)) {
                          return Loading(text: 'Obtendo dados...').build();
                        }

                        final items = snapshot.data.documents.reversed.toList();
                        return ChatMessage(
                            documents: items,
                            onFileDownloadStart: () => showFileLoading(true),
                            onFileDownloadEnd: (url, mineType) async {
                              OpenFile.open(url, type: mineType);
                              showFileLoading(false);
                            });
                      },
                    ),
                  ),
                  _isUploading
                      ? LinearProgressIndicator(
                          backgroundColor: Colors.amber,
                        )
                      : Container(),
                  TextComposer(
                    onCameraTap: (Future<PickedFile> file) {
                      showFileLoading(true);
                      file.then((pickedFile) async {
                        if (pickedFile != null) {
                          await Messenger(
                            filePath: pickedFile.path,
                            isImage: true,
                          ).send();
                        }
                        showFileLoading(false);
                      });
                    },
                    onFileAttach: (path, isTypeImage) async {
                      showFileLoading(true);
                      if (path != null) {
                        await Messenger(
                          filePath: path,
                          isImage: isTypeImage,
                        ).send();
                      }
                      showFileLoading(false);
                    },
                    onTextSubmitted: (text) => Messenger(text: text).send(),
                  ),
                ],
              ),
      ),
    );
  }

  _notLoggedScreen() => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(
          iconSize: 100,
          color: Colors.amber,
          tooltip: 'Login',
          alignment: Alignment.center,
          onPressed: () {
            setState(() {
              Auth().signIn();
            });
          },
          icon: Icon(Icons.assignment_ind),
        ),
        SimpleText('Necessário Login', size: 13)
      ]));
}
