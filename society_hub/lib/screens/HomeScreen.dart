import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/screens/WelcomeScreen.dart';
import 'package:sociaty_hub/services/AuthService.dart';
import 'package:sociaty_hub/services/Database.dart';
import 'package:sociaty_hub/constants/ConstantAttributes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String text;
  Stream newsfeed;
  Database database = Database();
  final AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("in HomeScreen");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: lightGrey,
              padding:
                  EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            text = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Create Post",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.grey[800],
                    onPressed: () {
                      uploadFeed(
                          userName: ConstantAttributes.myName, feedText: text);
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.all(15),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  uploadFeed({userName, feedText}) {
    Database database = Database();

    Map<String, dynamic> postMap = {
      "name": userName,
      "post": feedText,
      "time": DateTime.now().millisecondsSinceEpoch
    };

    database.uploadPost(postMap);
  }

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
