import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sociaty_hub/screens/ChatScreen.dart';
import 'package:sociaty_hub/screens/ProfileScreen.dart';
import '../../constants/ConstantColors.dart';
import '../../screens/HomeScreen.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currIndex = 0;
  PageTransitionType pageTransitionType = PageTransitionType.fade;
  List<Widget> widgetOption = [HomeScreen(), ProfileScreen(), ChatScreen()];
  _onIconTapped(int index) {
    setState(() {
      if (currIndex != index) {
        currIndex = index;
        pageTransitionType = checkIndex(index, currIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOption.elementAt(currIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: white,
        color: darkGrey,
        height: 55,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.decelerate,
        items: [
          Icon(
            Icons.home_filled,
            color: white,
          ),
          Icon(
            Icons.person,
            color: white,
          ),
          Icon(
            Icons.list,
            color: white,
          ),
        ],
        index: 0,
        onTap: _onIconTapped,
      ),
    );
  }

  PageTransitionType checkIndex(int index, int currIndex) {
    print("Index is $index");
    print("CurrIndex is $currIndex");
    print("currIndex");
    if (index > currIndex) return PageTransitionType.rightToLeft;
    return PageTransitionType.leftToRight;
  }
}
