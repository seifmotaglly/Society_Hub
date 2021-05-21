import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/models/ChatUser.dart';
import 'package:sociaty_hub/widgets/conversationList.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 20,
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
