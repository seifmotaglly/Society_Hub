import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantAttributes.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/constants/ConstantFunctions.dart';
import 'package:sociaty_hub/models/ChatUser.dart';
import 'package:sociaty_hub/screens/ChatDetailScreen.dart';
import 'package:sociaty_hub/services/Database.dart';

class ChatScreen extends StatefulWidget {
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
                  return chatTile(
                      username: snapshot.data.docs[index]["chatroomid"]
                          .toString()
                          .replaceAll("_", '')
                          .replaceAll(";", "")
                          .replaceAll(ConstantAttributes.myName, ""),
                      chatRoomId: snapshot.data.docs[index]["chatroomid"]);
                })
            : Container();
      },
    );
  }

  initiateSearch() {
    print("first print");
    setState(() {
      Update();
    });
  }

  Future<void> Update() async {
    print("updating");
    searchSnapshot = await databaseReference.getUserByUsername(searchText);
  }

  createChatRoom({String username}) {
    if (username != ConstantAttributes.myName) {
      String chatRoomId = getChatRoomId(username, ConstantAttributes.myName);
      List<String> users = [username, ConstantAttributes.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId
      };
      Database().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatDetailPage(chatRoomId: chatRoomId)));
    } else {
      print("u cant send a message to u ");
    }
  }

  Widget SearchTile({String username, String email}) {
    return Container(
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
              createChatRoom(username: username);
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
    ConstantAttributes.myName = await ConstantFunctions.getUserName();
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
              return SearchTile(
                  username: searchSnapshot.docs[index]["name"],
                  email: searchSnapshot.docs[index]["email"]);
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Conversations",
                      style: TextStyle(
                          color: darkGrey,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: blue,
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.blue[900],
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Add New",
                            style: TextStyle(
                                color: darkGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                onChanged: (searchText) {
                  setState(() => this.searchText = searchText.toLowerCase());
                },
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: GestureDetector(
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    onTap: () {
                      initiateSearch();
                    },
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.white)),
                  fillColor: Colors.grey[300],
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                child: searchList()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: chatRoomList(),
            )
          ],
        ),
      ),
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

class chatTile extends StatelessWidget {
  final String username;
  final String chatRoomId;
  chatTile({this.username, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetailPage(chatRoomId: chatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: 40,
                width: 40,
                child: Text(
                  "${username.substring(0, 1).toUpperCase()}",
                  style: TextStyle(color: white),
                ),
                decoration: BoxDecoration(
                    color: darkGrey, borderRadius: BorderRadius.circular(40))),
            SizedBox(width: 8),
            Text(
              username,
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
