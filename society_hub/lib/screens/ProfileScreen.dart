import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sociaty_hub/models/User.dart';
import 'package:sociaty_hub/screens/EditProfile.dart';
import 'package:sociaty_hub/widgets/progress.dart';

import '../constants/ConstantColors.dart';

final DateTime timestamp = DateTime.now();
User currentUser;

// final StorageReference storageRef = FirebaseStorage.instance.ref();
final CollectionReference usersRef =
    FirebaseFirestore.instance.collection('users');
final CollectionReference postsRef =
    FirebaseFirestore.instance.collection('posts');
final CollectionReference commentsRef =
    FirebaseFirestore.instance.collection('comments');
final CollectionReference friendsRef =
    FirebaseFirestore.instance.collection('friends');
final CollectionReference timelineRef =
    FirebaseFirestore.instance.collection('timeline');

class ProfileScreen extends StatefulWidget {
  final String profileId;

  ProfileScreen({this.profileId});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String currentUserId = "useridhere";
  String profileId = "YUf6xZx3sVLGPKalnlHg";
  bool isLoading = false;
  bool isFriend = false;
  bool isProfileOwner = false;
  int postCount = 0;
  // User user = new User(
  //     id: "id",
  //     username: "Diaa Jamal",
  //     photoUrl:
  //         "https://qph.fs.quoracdn.net/main-qimg-20df28f3b31895e56cba6dbc0515c635",
  //     email: "this.email",
  //     displayName: "Leavei",
  //     bio: "Our collage is shieeet");

  void initState() {
    super.initState();
    print('Profile ID: ${widget.profileId}');
    checkIfFriend();
  }

  @override
  Widget build(BuildContext context) {
    print("in Profile");
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Julee',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkGrey,
      ),
      body: ListView(
        children: [
          buildProfileHeader(),
          Divider(),
        ],
      ),
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

  buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.doc(profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(user.photoUrl)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[buildProfileButton()],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  user.username,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  user.displayName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 2),
                child: Text(user.bio),
              )
            ],
          ),
        );
      },
    );
  }

  buildProfileButton() {
    print("id");
    print(widget.profileId);
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return buildButton(text: 'Edit Profile', function: editProfile);
    } else if (isFriend) {
      return buildButton(text: "Remove Friend", function: handleUnFriend);
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
            width: 250.0,
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

  editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(currentUserId: currentUserId),
      ),
    );
  }
}
