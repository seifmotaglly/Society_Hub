import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sociaty_hub/constants/ConstantAttributes.dart';
import 'package:sociaty_hub/models/User.dart';
import 'package:uuid/uuid.dart';

class Database {
  final databaseReference = FirebaseFirestore.instance;

  getUserByUsername(String username) async {
    return await databaseReference
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByEmail(String email) async {
    return await databaseReference
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  getUsernameById(String id) async {
    try {
      return await databaseReference
          .collection("users")
          .where("id", isEqualTo: id)
          .get();
    } catch (e) {
      print(e.toString());
    }
  }

  uploadUserDate(userMap) {
    databaseReference.collection("users").doc(User.myUser.id).set(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    try {
      databaseReference.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap);
    } catch (e) {
      print(e.toString());
    }
  }

  addConversationMessages(String chatRoomId, messageMap) {
    try {
      databaseReference
          .collection("ChatRoom")
          .doc(chatRoomId)
          .collection("chats")
          .add(messageMap);
    } catch (e) {
      print(e.toString());
    }
  }

  getConversationMessages(String chatRoomId) async {
    try {
      print("uploading message");
      return databaseReference
          .collection("ChatRoom")
          .doc(chatRoomId)
          .collection("chats")
          .orderBy("time", descending: false)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
  }

  getChatRooms(String username) async {
    return databaseReference
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }

  readMessage(
      String username, String username2, String chatRoomId, bool isRead2) {
    databaseReference.collection("ChatRoom").doc(chatRoomId).update({
      "isRead": {username: true, username2: isRead2}
    });
  }

  uploadPost(postMap, String postId) {
    print("heeel");
    try {
      databaseReference.collection("posts").doc(postId).set(postMap);
    } catch (e) {
      print(e.toString());
    }
  }

  getPost() async {
    print("User ID");
    print(
        "${databaseReference.collection("users").doc("YUf6xZx3sVLGPKalnlHg").id}");
    try {
      return databaseReference
          .collection("posts")
          .orderBy("time", descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
  }

  getLikedList(String postId) async {
    DocumentReference doc =
        await databaseReference.collection("posts").doc(postId);
    doc.get().then((value) => print(value.data));
    print("heyyyy $doc");
  }
}
