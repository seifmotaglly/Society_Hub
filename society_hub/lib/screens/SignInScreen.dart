import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';
import 'package:sociaty_hub/constants/ConstantDecoration.dart';
import 'package:sociaty_hub/screens/HomeScreen.dart';
import 'package:sociaty_hub/screens/SignUpScreen.dart';
import 'package:sociaty_hub/services/AuthService.dart';
import 'package:string_validator/string_validator.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

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
                  Center(
                    child: Text(
                      "Sign in to get closer to your friends",
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 50),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
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
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        print("Valid");
                        dynamic result = await _auth.signIn(email, password);
                        if (result == null) {
                          setState(() => err = "something went wrong");
                          print(err);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        }
                      }
                    },
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
                            onPressed: () => Navigator.pushReplacement(
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
      ),
    );
  }
}
