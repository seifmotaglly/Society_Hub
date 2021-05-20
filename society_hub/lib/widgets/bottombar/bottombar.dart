import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sociaty_hub/screens/ProfileScreen.dart';

import '../../constants/ConstantColors.dart';
import '../../screens/HomeScreen.dart';

class BottomBar extends StatefulWidget {
  final int _index;

  BottomBar(this._index);

  @override
  _BottomBarState createState() => _BottomBarState(_index);
}

class _BottomBarState extends State<BottomBar> {
  _BottomBarState(this._index);
  int _index;
  _onIconTapped(int index) {
    setState(() {
      print("IconTapped ");
      if (_index != index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
            break;
          case 1:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
            break;
          default:
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: darkGrey,
      items: [
        Icon(
          Icons.home_filled,
        ),
        Icon(
          Icons.person,
        ),
        Icon(Icons.list),
      ],
      index: _index,
      onTap: _onIconTapped,
    );
  }
}
