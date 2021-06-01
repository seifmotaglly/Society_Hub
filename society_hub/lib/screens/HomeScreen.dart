import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantAttributes.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/models/User.dart';
import 'package:sociaty_hub/screens/WelcomeScreen.dart';
import 'package:sociaty_hub/services/AuthService.dart';
import 'package:sociaty_hub/services/Database.dart';
import 'package:sociaty_hub/widgets/progress.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  uploadPost(String text) => createState().uploadFeed(feedText: text);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum MenuOption { Delete, Edit }

class _HomeScreenState extends State<HomeScreen> {
  String text;
  Stream newsfeed;
  Database database = Database();
  TextEditingController postText = TextEditingController();
  final AuthService _auth = AuthService();

  // Widget newsFeedList() {
  //   return StreamBuilder(
  //     stream: newsfeed,
  //     builder: (context, snappshot) {
  //       print("printing");
  //       return snappshot.hasData
  //           ? ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: snappshot.data.docs.length,
  //               // physics: NeverScrollableScrollPhysics(),
  //               itemBuilder: (context, index) {
  //                 print("hello this from home screen tryiing");
  //                 print("${snappshot.data.docs[index]["post"]}");

  //                 return makeFeed(
  //                     username: snappshot.data.docs[index]["name"],
  //                     text: snappshot.data.docs[index]["post"]);
  //               },
  //             )
  //           : circularProgress();
  //     },
  //   );
  // }

  Widget newsFeedList() {
    return StreamBuilder(
      stream: newsfeed,
      builder: (context, snappshot) {
        print("printing");
        return snappshot.hasData
            ? CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return headerPost();
                  }, childCount: 1)),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return makeFeed(
                        username: snappshot.data.docs[index]["name"],
                        text: snappshot.data.docs[index]["post"],
                        postId: snappshot.data.docs[index]["postId"]);
                  }, childCount: snappshot.data.docs.length))
                ],
              )
            : circularProgress();
      },
    );
  }

  @override
  void initState() {
    database.getPost().then((value) {
      setState(() {
        newsfeed = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("in HomeScreen");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: lightGrey,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Sociaty Hub',
            style: TextStyle(
              fontFamily: 'Julee',
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: darkGrey,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                })
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: <Widget>[SizedBox(height: 15), newsFeedList()],
          ),
        ),
      ),
    );
  }

  uploadFeed({feedText, postId}) {
    Database database = Database();

    var likedList = List();
    likedList.add(12);
    likedList.add(13);

    Map<String, dynamic> postMap = {
      "name": ConstantAttributes.myName,
      "post": feedText,
      "image": User.myUser.photoUrl,
      "time": DateTime.now().millisecondsSinceEpoch,
      "postId": postId,
      "likedList": likedList
    };
    database.uploadPost(postMap, postId);
  }

  Widget headerPost() {
    final postId = Uuid().v4();

    return Container(
        margin: EdgeInsets.only(top: 20),
        color: lightGrey,
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: darkGrey)),
              padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      User.myUser.photoUrl),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Transform.translate(
                          offset: Offset(0, 5),
                          child: Text(
                            User.myUser.username,
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, bottom: 5),
                            child: TextField(
                              controller: postText,
                              maxLines: null,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  hintText: "Hey!, what's on your mind"),
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              if (postText.text.isNotEmpty) {
                                uploadFeed(
                                    feedText: postText.text, postId: postId);
                                postText.clear();
                              }
                            })
                      ],
                    )
                  ]))
        ]));
  }

  Widget makeFeed({String username, String text, String postId}) {
    bool isLiked = false;

    database.getLikedList(postId);
    return Container(
        margin: EdgeInsets.only(top: 20),
        color: lightGrey,
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: darkGrey)),
              padding: EdgeInsets.only(top: 5, left: 10, bottom: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // margin: EdgeInsets.symmetric(horizontal: 130),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        User.myUser.photoUrl),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        SizedBox(width: 10),
                        Transform.translate(
                          offset: Offset(0, 5),
                          child: Text(
                            username,
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                        ),
                        Spacer(),
                        PopupMenuButton<MenuOption>(
                            itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<MenuOption>>[
                            PopupMenuItem(
                                child: Text('Delete'),
                                value: MenuOption.Delete),
                            PopupMenuItem(
                                child: Text('Edit'), value: MenuOption.Edit)
                          ];
                        }),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[800],
                          height: 1.5,
                          letterSpacing: .7),
                    ),
                    Divider(
                      height: 20,
                    ),
                    Row(
                      children: [
                        IconButton(
                            icon: isLiked
                                ? Icon(Icons.thumb_up_alt)
                                : Icon(Icons.thumb_up_alt_outlined),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            }),
                        IconButton(
                            icon: isLiked
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_outline),
                            onPressed: () {
                              setState(() {
                                isLiked != isLiked;
                              });
                            })
                      ],
                    )
                  ]))
        ]));
  }
}
