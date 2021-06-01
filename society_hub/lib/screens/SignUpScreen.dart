import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantAttributes.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/constants/ConstantDecoration.dart';
import 'package:sociaty_hub/constants/ConstantFunctions.dart';
import 'package:sociaty_hub/models/User.dart';
import 'package:sociaty_hub/screens/SignInScreen.dart';
import 'package:sociaty_hub/screens/Wrapper.dart';
import 'package:sociaty_hub/services/AuthService.dart';
import 'package:sociaty_hub/services/Database.dart';
import 'package:string_validator/string_validator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final databaseRefrence = Database();

  String userName = "";
  String email = "";
  String password = "";
  String err = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGrey,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(height: 90),
                  Text(
                    "Sign up to meet new friends",
                    style: TextStyle(color: white, fontSize: 18),
                  ),
                  SizedBox(height: 50),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (userName) =>
                                isLowercase(userName) & userName.isNotEmpty
                                    ? null
                                    : "username must be lowercase",
                            decoration:
                                decoratedInput.copyWith(hintText: "User name"),
                            onChanged: (userName) {
                              setState(() {
                                this.userName = userName;
                                ConstantAttributes.myName = userName;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (email) =>
                                isEmail(email) ? null : "enter a valid email",
                            decoration:
                                decoratedInput.copyWith(hintText: "Email"),
                            onChanged: (email) {
                              setState(() => this.email = email);
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (password) => password.length < 8
                                ? "enter password more 8 characters"
                                : null,
                            decoration:
                                decoratedInput.copyWith(hintText: "Password"),
                            obscureText: true,
                            onChanged: (password) {
                              setState(() => this.password = password);
                            },
                          ),
                        ],
                      )),
                  SizedBox(height: 40),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    color: white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: white),
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result =
                            await _auth.signUp(userName, email, password);
                        if (result == null) {
                          setState(() => err = "something went wrong");
                          print(err);
                        } else {
                          Map<String, String> userInfoMap = {
                            "name": userName,
                            "email": email,
                            "id": User.myUser.id,
                            "bio": User.myUser.bio,
                            "photo_url": User.myUser.photoUrl,
                            "display_name": User.myUser.displayName
                          };
                          databaseRefrence.uploadUserDate(userInfoMap);
                          ConstantFunctions.saveEmail(email);
                          ConstantFunctions.saveUserName(userName);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper()));
                        }
                      }
                    },
                    child: Text("Sign up",
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
                        Text("Do you have an account ? ",
                            style: TextStyle(color: white)),
                        TextButton(
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen())),
                            child: Text("Sign in",
                                style: TextStyle(color: white, fontSize: 20)))
                      ]),
                  SizedBox(height: 20),
                  Image.asset("assets/images/signup.png")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
