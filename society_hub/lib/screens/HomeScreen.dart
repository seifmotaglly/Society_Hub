import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantAttributes.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/models/User.dart';
import 'package:sociaty_hub/screens/WelcomeScreen.dart';
import 'package:sociaty_hub/services/AuthService.dart';
import 'package:sociaty_hub/services/Database.dart';
import 'package:sociaty_hub/widgets/progress.dart';

class HomeScreen extends StatefulWidget {
  uploadPost(String text) => createState().uploadFeed(feedText: text);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String text;
  Stream newsfeed;
  bool isLiked = false;
  Database database = Database();
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
                        text: snappshot.data.docs[index]["post"]);
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
            children: <Widget>[
              SizedBox(height: 15),
              newsFeedList()
              // Container(
              //   color: lightGrey,
              //   padding:
              //       EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
              //   child: Row(
              //     children: <Widget>[
              //       Expanded(
              //         child: Container(
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(50),
              //               color: Colors.white),
              //           child: TextField(
              //             onChanged: (value) {
              //               setState(() {
              //                 text = value;
              //               });
              //             },
              //             decoration: InputDecoration(
              //               contentPadding: EdgeInsets.symmetric(horizontal: 10),
              //               border: InputBorder.none,
              //               hintStyle: TextStyle(color: Colors.grey),
              //               hintText: "Create Post",
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         width: 20,
              //       ),
              //       IconButton(
              //         icon: Icon(Icons.send),
              //         color: Colors.grey[800],
              //         onPressed: () {
              //           uploadFeed(
              //               userName: ConstantAttributes.myName, feedText: text);
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Expanded(
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.vertical,
              //     child: Padding(
              //       padding: EdgeInsets.all(15),
              //       child: newsFeedList(),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  uploadFeed({feedText}) {
    Database database = Database();

    Map<String, dynamic> postMap = {
      "name": ConstantAttributes.myName,
      "post": feedText,
      "image": User.myUser.photoUrl,
      "time": DateTime.now().millisecondsSinceEpoch
    };
    database.uploadPost(postMap);
  }

  Widget headerPost() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        color: lightGrey,
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Transform.translate(
                        offset: Offset(0, -20),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      User.myUser.photoUrl),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -10),
                      child: Align(
                        child: Text(
                          User.myUser.username,
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 10, right: 70),
                        child: TextField(
                          maxLines: null,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              hintText: "Hey!, what's on your mind"),
                        ))
                  ]))
        ]));
  }

  Widget makeFeed({String username, String text}) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        color: lightGrey,
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Transform.translate(
                        offset: Offset(0, -20),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      User.myUser.photoUrl),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -10),
                      child: Align(
                        child: Text(
                          username,
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[800],
                          height: 1.5,
                          letterSpacing: .7),
                    ),
                    Divider(height: 20),
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

    // return Container(
    //   margin: EdgeInsets.only(top: 10),
    //   color: lightGrey,
    //   child: Column(children: [
    //     Container(
    //       decoration: BoxDecoration(
    //           color: white,
    //           borderRadius: BorderRadius.all(Radius.circular(15))),
    //       padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
    //       margin: EdgeInsets.only(bottom: 20),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Center(
    //             child: Transform.translate(
    //               offset: Offset(0, -20),
    //               child: Container(
    //                 width: 50,
    //                 height: 50,
    //                 decoration: BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     image: DecorationImage(
    //                         image: AssetImage(userImage), fit: BoxFit.cover)),
    //               ),
    //             ),
    //           ),
    //           Transform.translate(
    //             offset: Offset(0, -10),
    //             child: Align(
    //               child: Text(
    //                 userName,
    //                 style: TextStyle(
    //                     color: Colors.grey[900],
    //                     fontSize: 18,
    //                     fontWeight: FontWeight.bold,
    //                     letterSpacing: 1),
    //               ),
    //             ),
    //           ),
    //           SizedBox(
    //             height: 3,
    //           ),
    //           Align(
    //             child: Text(
    //               feedTime,
    //               style: TextStyle(fontSize: 15, color: Colors.grey),
    //             ),
    //           ),
    //           SizedBox(
    //             height: 20,
    //           ),
    //           Text(
    //             feedText,
    //             style: TextStyle(
    //                 fontSize: 15,
    //                 color: Colors.grey[800],
    //                 height: 1.5,
    //                 letterSpacing: .7),
    //           ),
    // SizedBox(
    //   height: 20,
    // ),
    // feedImage != ''
    //     ? Container(
    //         height: 200,
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(10),
    //             image: DecorationImage(
    //                 image: AssetImage(feedImage), fit: BoxFit.cover)),
    //       )
    //     : Container(),
    // SizedBox(
    //   height: 20,
    // ),
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: <Widget>[
    //     Row(
    //       children: <Widget>[
    //         makeLike(),
    //         Transform.translate(
    //             offset: Offset(-5, 0), child: makeLove()),
    //         SizedBox(
    //           width: 5,
    //         ),
    //         Text(
    //           "2.5K",
    //           style: TextStyle(fontSize: 15, color: Colors.grey[800]),
    //         )
    //       ],
    //     ),
    //     Text(
    //       "400 Comments",
    //       style: TextStyle(fontSize: 13, color: Colors.grey[800]),
    //     )
    //   ],
    // ),
    // SizedBox(
    //   height: 20,
    // ),
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: <Widget>[
    //     makeLikeButton(isActive: true),
    //     makeCommentButton(),
    //     makeShareButton(),
    //   ],
    // )
    //         ],
    //       ),
    //     )
    //   ]),
    // );
    // }
  }
}
