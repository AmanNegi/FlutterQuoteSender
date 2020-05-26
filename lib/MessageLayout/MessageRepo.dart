import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_sender/MessageLayout/Message.dart';

class MessageRepo {
  var reference = Firestore.instance.collection("Messages");

  void setReference(var groupId) {
    reference = Firestore.instance
        .collection("Messages")
        .document(groupId)
        .collection(groupId);
  }

  Stream<QuerySnapshot> getStream() {
    return reference.orderBy("date", descending: true).snapshots();
  }

  Future<void> addMessage(Message message) {
    return reference
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData(message.toJson());
  }

  void addMessages() {}
}
