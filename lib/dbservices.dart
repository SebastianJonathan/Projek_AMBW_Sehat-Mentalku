import 'package:cloud_firestore/cloud_firestore.dart';
import 'dataclass.dart';

CollectionReference listUser = FirebaseFirestore.instance.collection("userTable");
class Database{
  static Stream<QuerySnapshot> getData(){
    return listUser.snapshots();
  }
  static Future<void> addData({required user users}) async{
    DocumentReference doc = listUser.doc(users.username);
    await doc
    .set(users.toJson())
    .whenComplete(() => print("Data Masuk"))
    .catchError((e) => print(e));
  }
}