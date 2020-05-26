import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String id;
  String gender;

  DocumentReference reference;

  User({this.name, this.id, this.gender});

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    User message = User.fromJson(snapshot.data);
    message.reference = snapshot.reference;
    return message;
  }

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
        name: json['name'] as String,
        gender: json['gender'] as String,
        id: json['id'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id, 'gender': gender};
  }
}
