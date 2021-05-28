import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantAttributes.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/services/Database.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatRoomId;
  ChatDetailPage({this.chatRoomId});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final databaseReference = FirebaseFirestore.instance;
  Database databaseRefrence = Database();
  TextEditingController message = TextEditingController();

  Stream chatMessageStream;

  Widget chatMessagesList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          print("this is snapshot");
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    print(snapshot.data);
                    return ChatMessage(
                        message: snapshot.data.docs[index]["message"],
                        isSender: ConstantAttributes.myName ==
                            snapshot.data.docs[index]["sendBy"]);
                  })
              : Container();
        });
  }

  sendMessage() {
    Map<String, dynamic> messageMap;
    if (message.text.isNotEmpty) {
      messageMap = {
        "message": message.text,
        "sendBy": ConstantAttributes.myName,
        'time': DateTime.now().microsecondsSinceEpoch
      };
    }

    databaseRefrence.addConversationMessages(widget.chatRoomId, messageMap);

    setState(() {
      message.text = "";
      message.clear();
    });
  }

  @override
  void initState() {
    databaseRefrence.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: darkGrey,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/pic.png'),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Kriss Benwat",
                          style: TextStyle(
                              color: white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Online",
                          style: TextStyle(color: Colors.green, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 60),
              child: chatMessagesList(),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: darkGrey,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (message) {
                          setState(() {
                            this.message.text = message;
                          });
                        },
                        textInputAction: TextInputAction.go,
                        style: TextStyle(color: white),
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: white),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        sendMessage();
                      },
                      child: Icon(
                        Icons.send,
                        color: darkGrey,
                        size: 18,
                      ),
                      backgroundColor: white,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isSender;

  ChatMessage({this.message, this.isSender});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        alignment: isSender ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          child: Text(
            message,
            style: TextStyle(fontSize: 15),
          ),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: isSender ? Colors.blue[200] : Colors.grey.shade200,
              borderRadius: isSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23))
                  : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23))),
        ));
  }
}
