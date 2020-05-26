import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String text;
  DateTime date;
  String idFrom;
  String idTo;
  DocumentReference reference;

  Message({this.reference, this.text, this.date, this.idFrom, this.idTo});

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    Message message = Message.fromJson(snapshot.data);
    message.reference = snapshot.reference;
    return message;
  }

  factory Message.fromJson(Map<dynamic, dynamic> json) {
    return Message(
      text: json['text'] as String,
      date: json['date'] == null ? null : (json['date'] as Timestamp).toDate(),
      idFrom: json['idFrom'] as String,
      idTo: json['idTo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'date': date, 'idFrom': idFrom, 'idTo': idTo};
  }
}
