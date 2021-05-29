import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantAttributes.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/models/User.dart';
import 'package:sociaty_hub/screens/ChatDetailScreen.dart';
import 'package:sociaty_hub/services/Database.dart';

class ChatScreen extends StatefulWidget {
  creatChat(String id) => createState().createChatRoom(id: id);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController searchController = TextEditingController();
  Database databaseReference = Database();
  dynamic searchText = "";
  Stream chatRoomStream;
  QuerySnapshot searchSnapshot;

  Widget chatRoomList() {
    // return Container();
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  String username = snapshot.data.docs[index]["chatroomid"]
                      .toString()
                      .replaceAll("_", '')
                      .replaceAll(";", "")
                      .replaceAll(User.myUser.username, "");
                  return chatTile(
                      username: username,
                      chatRoomId: snapshot.data.docs[index]["chatroomid"],
                      isRead: snapshot.data.docs[index]["isRead"]
                          [ConstantAttributes.myName.toString()],
                      isRead2: snapshot.data.docs[index]["isRead"][username]);
                })
            : Container();
      },
    );
  }

  initiateSearch() {
    print("first print");
    setState(() {
      update();
    });
  }

  Future<void> update() async {
    print("updating");
    searchSnapshot = await databaseReference.getUserByUsername(searchText);
  }

  createChatRoom({String id}) async {
    String chatRoomId;
    if (id != User.myUser.id) {
      Database database = Database();
      QuerySnapshot snapshot = await database.getUsernameById(id);
      String username = snapshot.docs[0]["name"];
      chatRoomId = getChatRoomId(username, ConstantAttributes.myName);
      List<String> users = [username, ConstantAttributes.myName];
      Map<String, bool> isRead = {
        ConstantAttributes.myName.toString(): false,
        username.toString(): false
      };
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId,
        "isRead": isRead
      };
      Database().createChatRoom(chatRoomId, chatRoomMap);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ChatDetailPage(chatRoomId: chatRoomId)));
    } else {
      print("u cant send a message to u ");
    }
    return chatRoomId;
  }

  Widget searchTile({String username, String email}) {
    return Container(
      height: 40,
      width: double.infinity,
      color: lightGrey,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: TextStyle(fontSize: 22)),
              Text(email),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoom(id: username);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: blue, borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("Message")),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    // ConstantAttributes.myName = await ConstantFunctions.getUserName();
    setState(() {
      databaseReference.getChatRooms(ConstantAttributes.myName).then((value) {
        setState(() {
          chatRoomStream = value;
        });
      });
    });
  }

  Widget searchList() {
    print("search querey is ${searchSnapshot.toString()}");
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print("$index");
              print(searchSnapshot.docs.toString());
              print(searchSnapshot.docs[index]["email"]);
              return searchTile(
                  username: searchSnapshot.docs[index]["id"],
                  email: searchSnapshot.docs[index]["email"]);
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkGrey,
          title: Text("Chats"),
        ),
        body: Stack(
          children: [chatRoomList()],
        )
        // appBar: AppBar(
        //   title: Text("hello"),
        // ),
        // body: Container(child: chatRoomList()),
        );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
    return "$b\_$a;";
  else
    return "$a\_$b;";
}

class chatTile extends StatefulWidget {
  final String username;
  final String chatRoomId;
  bool isRead;
  bool isRead2;
  chatTile({this.username, this.chatRoomId, this.isRead, this.isRead2});

  @override
  _chatTileState createState() => _chatTileState();
}

class _chatTileState extends State<chatTile> {
  Database _database = Database();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _database.readMessage(ConstantAttributes.myName, widget.username,
            widget.chatRoomId, widget.isRead2);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatDetailPage(chatRoomId: widget.chatRoomId)));
        setState(() {
          widget.isRead = true;
        });
      },
      child: Container(
        color: lightGrey,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: 40,
                width: 40,
                child: Text(
                  "${widget.username.substring(0, 1).toUpperCase()}",
                  style: widget.isRead
                      ? TextStyle(color: white)
                      : TextStyle(color: Colors.red),
                ),
                decoration: BoxDecoration(
                    color: darkGrey, borderRadius: BorderRadius.circular(40))),
            SizedBox(width: 8),
            Text(
              widget.username,
              style: TextStyle(
                color: darkGrey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
