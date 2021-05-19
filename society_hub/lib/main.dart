import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/screens/LoadingScreen.dart';
import 'package:sociaty_hub/screens/SignInScreen.dart';
import 'package:sociaty_hub/screens/WelcomeScreen.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SociatyHub(),
    ));

class SociatyHub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScreen();
  }
}
