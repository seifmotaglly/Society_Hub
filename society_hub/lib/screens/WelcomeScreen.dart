import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/screens/SignInScreen.dart';
import 'SignUpScreen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGrey,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  RichText(
                      text: TextSpan(
                          text: "Welcome to ",
                          style: TextStyle(color: Colors.white),
                          children: <TextSpan>[
                        TextSpan(
                            text: "Sociaty ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        TextSpan(
                            text: "Hub",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22))
                      ])),
                  SizedBox(height: 20),
                  Image.asset(
                    "assets/images/welcome.png",
                    scale: 1.5,
                  ),
                  SizedBox(height: 20),
                  Text("Come along with friends",
                      style: TextStyle(color: white)),
                  SizedBox(height: 70),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: white),
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen())),
                    child: Text("Sign in",
                        style: TextStyle(
                            color: white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 30),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: white),
                        borderRadius: BorderRadius.circular(50)),
<<<<<<< HEAD
                    onPressed: () => Navigator.push(
=======
                    onPressed: () => Navigator.pushReplacement(
>>>>>>> homepage
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen())),
                    child: Text("Sign up",
                        style: TextStyle(
                            color: white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
