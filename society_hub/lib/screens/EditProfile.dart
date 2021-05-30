import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sociaty_hub/models/User.dart';
import 'package:sociaty_hub/widgets/progress.dart';
import 'ProfileScreen.dart';
import 'package:path/path.dart' as Path;

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
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  User user;
  bool userNameValidation = true;
  bool displayNameValidation = true;
  PickedFile _image;
  File _imageFile;

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
    bioController.text = user.bio;
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
          ),
        ),
      ],
    );
  }

  Column updateBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Bio',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: 'Update your bio',
          ),
        ),
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
          'name': userNameController.text,
          'bio': bioController.text,
          'photo_url': user.photoUrl
        });
        User.myUser.photoUrl = user.photoUrl;
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
                        child: GestureDetector(
                          onTap: () {
                            print("tappe");
                            chooseFile();
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(user.photoUrl),
                            radius: 50.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            displayNameField(),
                            userNameField(),
                            updateBio(),
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

  Future chooseFile() async {
    final _picker = ImagePicker();
    await _picker.getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
        _imageFile = File(image.path);
      });
    });
    uploadFile();
  }

  Future uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    UploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.whenComplete(() => print('File Uploaded'));
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        user.photoUrl = fileURL;
      });
    });
  }
}
