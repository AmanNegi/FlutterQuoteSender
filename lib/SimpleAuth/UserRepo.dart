import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_sender/MessageLayout/Message.dart';
import 'User.dart';

class UserRepo {
  CollectionReference reference = Firestore.instance.collection("User");

  Stream<QuerySnapshot> getStream() {
    return reference.snapshots();
  }

  Future<DocumentReference> addUser(User user) {
    return reference.add(user.toJson());
  }

  updateUser(User newUser) async {
    await reference.document(newUser.id).updateData(newUser.toJson());
  }
}
