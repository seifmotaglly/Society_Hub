import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    print("In Edit Profile Screen");
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: darkGrey,
      ),
    );
  }
}
