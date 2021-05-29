import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/screens/Wrapper.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Wrapper()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkGrey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/logo1.png", height: 300),
            SizedBox(height: 30),
            SpinKitRing(color: white),
          ]),
    );
  }
}
