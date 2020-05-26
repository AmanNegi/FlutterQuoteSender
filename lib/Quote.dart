import 'package:cloud_firestore/cloud_firestore.dart';

class Quote {
  String quote;
  String author;
  DateTime date;
  String imageUrl;

  DocumentReference reference;
  Quote({this.quote, this.author, this.date, this.reference, this.imageUrl});

  factory Quote.fromSnapshot(DocumentSnapshot snapshot) {
    Quote quote = Quote.fromJson(snapshot.data);
    quote.reference = snapshot.reference;
    return quote;
  }

  factory Quote.fromJson(Map<dynamic, dynamic> json) {
    return Quote(
        author: json['author'] as String,
        date:
            json['date'] == null ? null : (json['date'] as Timestamp).toDate(),
        quote: json['quote'] as String,
        imageUrl: json['imageUrl'] as String);
  }
  
  Map<String, dynamic> toJson() {
    return {
      'quote': quote,
      'date': date,
      'author': author,
      'imageUrl': imageUrl
    };
  }
}
