import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sociaty_hub/models/User.dart';
import 'package:sociaty_hub/widgets/progress.dart';
import 'ProfileScreen.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  bool isLoading = false;
  User user;
  bool userNameValidation = true;
  bool displayNameValidation = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    userNameController.text = user.username;
    setState(() {
      isLoading = false;
    });
  }

  Column displayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Display Name',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
              hintText: 'Update Display Name',
              errorText:
                  displayNameValidation ? null : 'Display name too short'),
        )
      ],
    );
  }

  Column userNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'User Name',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: userNameController,
          decoration: InputDecoration(
              hintText: 'Update User Name',
              errorText: userNameValidation ? null : 'User name too short'),
        )
      ],
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? displayNameValidation = false
          : displayNameValidation = true;

      userNameController.text.trim().length > 100
          ? userNameValidation = false
          : userNameValidation = true;

      if (displayNameValidation && userNameValidation) {
        usersRef.doc(widget.currentUserId).update({
          'display_name': displayNameController.text,
          'name': userNameController.text
        });
      }
    });
    SnackBar snackbar = SnackBar(
      content: Text('Profile updated'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 8),
                        child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(user.photoUrl),
                          radius: 50.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            displayNameField(),
                            userNameField()
                          ],
                        ),
                      ),
                      ElevatedButton(
                          onPressed: updateProfileData,
                          child: Text('Update Profile'))
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
