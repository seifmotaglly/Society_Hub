import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sociaty_hub/models/User.dart';
import 'package:sociaty_hub/screens/ChatDetailScreen.dart';
import 'package:sociaty_hub/screens/ChatScreen.dart';
import 'package:sociaty_hub/screens/EditProfile.dart';
import 'package:sociaty_hub/screens/MakeFeedScreen.dart';
import 'package:sociaty_hub/services/Database.dart';
import 'package:sociaty_hub/widgets/progress.dart';

import '../constants/ConstantColors.dart';

final CollectionReference usersRef =
    FirebaseFirestore.instance.collection('users');
final CollectionReference friendsRef =
    FirebaseFirestore.instance.collection('friends');

class ProfileScreen extends StatefulWidget {
  final String profileId;

  ProfileScreen({this.profileId});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Database databaseRefrence = Database();
  final String currentUserId = User.myUser.id;
  bool isLoading = false;
  bool isFriend = false;
  bool isProfileOwner = false;
  void initState() {
    print("current user is ");
    print(currentUserId.toString());
    print("profile is ");
    print(widget.profileId.toString());
    super.initState();
    print('Profile ID: ${widget.profileId}');
    checkIfFriend();
  }

  @override
  Widget build(BuildContext context) {
    print("in Profile");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Julee',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(),
        backgroundColor: darkGrey,
      ),
      body: ListView(
        children: [
          buildProfileHeader2(),
          Divider(),
        ],
      ),
    );
  }

  buildProfileHeader2() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(widget.profileId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //Test data existence
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User _user = User.fromDocument(snapshot.data);
        return Stack(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: _user.photoUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 150.0, 16.0, 16.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 96.0),
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Text(
                                    _user.username,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Text('${_user.displayName}')
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: [
                                Expanded(child: buildProfileButton()),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(_user.bio),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: NetworkImage(_user.photoUrl),
                                fit: BoxFit.cover)),
                        margin: EdgeInsets.only(left: 16.0),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  checkIfFriend() async {
    DocumentSnapshot doc = await friendsRef
        .doc(widget.profileId)
        .collection('userFriends')
        .doc(currentUserId)
        .get();
    setState(() {
      isFriend = doc.exists;
    });
  }

  buildProfileButton() {
    print("id");
    print(widget.profileId);
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        buildButton(text: 'Edit Profile', function: editProfile),
        makeFeed()
      ]);
    } else if (isFriend) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        buildButton(text: "Remove Friend", function: handleUnFriend),
        SizedBox(width: 10),
        messageButton(widget.profileId)
      ]);
    } else if (!isFriend) {
      return buildButton(text: "Add Friend", function: handleAddFriend);
    }
  }

  handleUnFriend() {
    setState(() {
      isFriend = false;
    });

    friendsRef
        .doc(widget.profileId)
        .collection('userFriends')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleAddFriend() {
    setState(() {
      isFriend = true;
    });

    friendsRef
        .doc(widget.profileId)
        .collection('userFriends')
        .doc(currentUserId)
        .set({});
  }

  Container buildButton({String text, Function function}) {
    return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: TextButton(
          onPressed: function,
          child: Container(
            width: isFriend ? 100 : 100.0,
            height: 27.0,
            decoration: BoxDecoration(
              color: isFriend ? Colors.white : Colors.blue,
              border: Border.all(color: isFriend ? Colors.grey : Colors.blue),
              borderRadius: BorderRadius.circular(5.0),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                  color: isFriend ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  Container messageButton(String id) {
    return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: TextButton(
          onPressed: () async {
            String chatRoomId = await ChatScreen().creatChat(id);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatDetailPage(chatRoomId: chatRoomId)));
          },
          child: Container(
            width: 100.0,
            height: 27.0,
            decoration: BoxDecoration(
              color: isFriend ? Colors.white : Colors.blue,
              border: Border.all(color: isFriend ? Colors.grey : Colors.blue),
              borderRadius: BorderRadius.circular(5.0),
            ),
            alignment: Alignment.center,
            child: Text(
              "Message",
              style: TextStyle(
                  color: isFriend ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  Container makeFeed() {
    return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MakeFeedScreen()));
          },
          child: Container(
            width: 100.0,
            height: 27.0,
            decoration: BoxDecoration(
              color: isFriend ? Colors.white : Colors.blue,
              border: Border.all(color: isFriend ? Colors.grey : Colors.blue),
              borderRadius: BorderRadius.circular(5.0),
            ),
            alignment: Alignment.center,
            child: Text(
              "Add post",
              style: TextStyle(
                  color: isFriend ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(currentUserId: currentUserId),
      ),
    );
  }
}
