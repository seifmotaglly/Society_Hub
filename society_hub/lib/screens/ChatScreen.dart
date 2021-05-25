import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/models/ChatUser.dart';
import 'package:sociaty_hub/services/Database.dart';
import 'package:sociaty_hub/widgets/conversationList.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController searchController = TextEditingController();
  Database databaseReference = Database();
  dynamic searchText = "";
  List<ChatUser> chatUsers = [
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/pic.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
    ChatUser(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        image: "asset/images/logo.png",
        time: "Now"),
  ];

  QuerySnapshot searchSnapshot;

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
                  username: searchSnapshot.docs[index]["email"], email: "");
            })
        : null;
  }

  initiateSearch() {
    print("first print");
    setState(() {
      Update();
    });
  }

  createChatRoom() {}

  Future<void> Update() async {
    searchSnapshot = await databaseReference.getUserByUsername(searchText);
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
                  setState(() => this.searchText = searchText);
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
                      ;
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
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: searchList()),
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  image: chatUsers[index].image,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String username;
  final String email;

  SearchTile({this.username, this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(username),
              Text(email),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {},
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
}
