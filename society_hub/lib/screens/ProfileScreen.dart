import 'package:flutter/material.dart';
import 'package:sociaty_hub/widgets/bottombar/bottombar.dart';

import '../constants/ConstantColors.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("in Profile");
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Julee',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkGrey,
      ),
      bottomNavigationBar: BottomBar(1),
    );
  }
}
