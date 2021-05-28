import 'package:cloud_firestore/cloud_firestore.dart';

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

  uploadUserDate(userMap) {
    databaseReference.collection("users").add(userMap);
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
      return await databaseReference
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
    return await databaseReference
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

  uploadPost(postMap) {
    print("heeel");
    try {
      databaseReference.collection("posts").add(postMap);
    } catch (e) {
      print(e.toString());
    }
  }

  getPost() async {
    try {
      return await databaseReference
          .collection("posts")
          .orderBy("time", descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
  }
}
