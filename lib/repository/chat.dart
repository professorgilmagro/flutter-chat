import 'package:chat_app/models/message.dart';
import 'package:chat_app/storage/db.dart';

class ChatRepository {
  Message message;
  ChatRepository(this.message);

  Future<void> push() async {
    return await DB.create(message.toMap());
  }

  Future<void> save() async {
    return await DB.update(id: message.id, data: message.toMap());
  }

  Future<void> delete() async {
    return await DB.delete(message.id);
  }
}
