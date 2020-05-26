import 'package:cloud_firestore/cloud_firestore.dart';
import 'Quote.dart';

class DataRepo {
  final CollectionReference collection =
      Firestore.instance.collection("Quotes");

  Stream<QuerySnapshot> getStream() {
    return collection.orderBy('date', descending: true).snapshots();
  }

  Future<DocumentReference> addQuote(Quote quote) {
    return collection.add(quote.toJson());
  }
}
