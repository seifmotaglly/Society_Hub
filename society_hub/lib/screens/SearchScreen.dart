import 'package:flutter/material.dart';
import 'package:sociaty_hub/constants/ConstantColors.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
        backgroundColor: darkGrey,
      ),
    );
  }
}
