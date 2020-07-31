import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference resultCollection =
      Firestore.instance.collection('result_dry');

  Future updateUserData(String result_dry) async {
    return await resultCollection.document(uid).setData({
      'Driest month': result_dry + " litres",
    });
  }

  Stream<QuerySnapshot> get results {
    return resultCollection.snapshots();
  }
}
