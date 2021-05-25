import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/screens/WelcomeScreen.dart';
import 'package:sociaty_hub/services/AuthService.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    print("in HomeScreen");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: white,
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
      ),
    );
  }
}
