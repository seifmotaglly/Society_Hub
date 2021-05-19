import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Sociaty Hub"),
          centerTitle: true,
          backgroundColor: darkGrey,
        ),
      ),
    );
  }
}
