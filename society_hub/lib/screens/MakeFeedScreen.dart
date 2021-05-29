import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/screens/HomeScreen.dart';

class MakeFeedScreen extends StatefulWidget {
  @override
  _MakeFeedScreenState createState() => _MakeFeedScreenState();
}

class _MakeFeedScreenState extends State<MakeFeedScreen> {
  String text = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: darkGrey,
          title: Text("Make post"),
          actions: [
            IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  HomeScreen().uploadPost(text);
                })
          ],
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: InputDecoration(
                  fillColor: lightGrey,
                  filled: true,
                  hintText: "What's on your mind"),
              onChanged: (text) {
                setState(() {
                  this.text = text;
                });
              },
            ),
          ),
        ));
  }
}
