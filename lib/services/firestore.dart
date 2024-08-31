import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get voc
  final CollectionReference words =
      FirebaseFirestore.instance.collection('voc');
  //add voc
  Future<void> addword(String voc, String trans, String pos) {
    return words.add({
      'voc': voc,
      'trans': trans,
      'pos': pos,
      'timestamp': Timestamp.now(),
    });
  }

  //read voc
  Stream<QuerySnapshot> getwordStream() {
    final wordStream = words.orderBy('timestamp', descending: true).snapshots();
    return wordStream;
  }

  //update voc
  Future<void> updateWord(
      String docID, String newvoc, String newtrans, String newpos) {
    return words.doc(docID).update({
      'voc': newvoc,
      'trans': newtrans,
      'pos': newpos,
      'timestamp': Timestamp.now(),
    });
  }

  //delete voc
  Future<void> deleteWord(String docID) {
    return words.doc(docID).delete();
  }
}
