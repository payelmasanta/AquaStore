import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServicee {
  final String uid;
  DatabaseServicee({this.uid});
  final CollectionReference resultCollection =
      Firestore.instance.collection('result_wet');

  Future updateUserDataa(String result_wet) async {
    return await resultCollection.document(uid).setData({
      'Driest month': result_wet + " litres",
    });
  }

  Stream<QuerySnapshot> get results {
    return resultCollection.snapshots();
  }
}
