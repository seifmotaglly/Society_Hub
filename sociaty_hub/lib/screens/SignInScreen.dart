import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/constants/ConstantDecoration.dart';
import 'package:sociaty_hub/screens/SignUpScreen.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGrey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign in to get closer to your friends",
                  style: TextStyle(color: white, fontSize: 18),
                ),
                SizedBox(height: 50),
                Form(
                    child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: decoratedInput.copyWith(hintText: "Email"),
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: decoratedInput.copyWith(hintText: "Password"),
                      obscureText: true,
                      onChanged: (value) {},
                    ),
                  ],
                )),
                SizedBox(height: 20),
                TextButton(
                    onPressed: () {},
                    child: Text("Forgot your password ?",
                        style: TextStyle(color: white))),
                SizedBox(height: 5),
                MaterialButton(
                  color: white,
                  minWidth: double.infinity,
                  height: 60,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: white),
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => null)),
                  child: Text("Sign in",
                      style: TextStyle(
                          color: darkGrey,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("You don't have an account ? ",
                          style: TextStyle(color: white)),
                      TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen())),
                          child: Text("Sign up",
                              style: TextStyle(color: white, fontSize: 20)))
                    ]),
                SizedBox(height: 20),
                Image.asset("assets/images/signin.png")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
