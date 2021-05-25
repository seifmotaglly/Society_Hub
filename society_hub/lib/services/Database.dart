import 'package:sociaty_hub/models/SHUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final databaseReference = FirebaseFirestore.instance;

  getUserByUsername(String username) async {
    print("second print");
    print(databaseReference
        .collection("users")
        .where("name", isEqualTo: username)
        .get()
        .toString());
    return await databaseReference
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  uploadUserDate(userMap) {
    databaseReference.collection("users").add(userMap);
  }
}
