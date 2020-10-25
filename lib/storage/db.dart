import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DB {
  static const String COLLECTION_NAME = 'messages';

  static CollectionReference getCollection() {
    return Firestore.instance.collection(COLLECTION_NAME);
  }

  static Future<List<DocumentSnapshot>> getDocuments({int limit}) async {
    QuerySnapshot snapshot =
        await DB.getCollection().limit(limit).getDocuments();
    return snapshot.documents;
  }

  static Future<void> create(Map<String, dynamic> data) async {
    return await DB.getCollection().document().setData(data);
  }

  static Future<void> update(
      {@required String id, @required Map<String, dynamic> data}) async {
    return await DB.getCollection().document(id).updateData(data);
  }

  static Future<void> delete(dynamic id) async {
    return await DB.getCollection().document(id).delete();
  }

  static Future<DocumentSnapshot> findById(String id) async {
    return await DB.getCollection().document(id).get();
  }

  static collectionChangeDetect({Function onChanged}) {
    DB.getCollection().snapshots().listen((snapshot) {
      onChanged(snapshot.documentChanges);
    });
  }

  static itemChangeDetect({@required String id, @required Function onChanged}) {
    DB.getCollection().document(id).snapshots().listen((snapshot) {
      onChanged(snapshot.data);
    });
  }
}
