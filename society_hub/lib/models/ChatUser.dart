import 'package:flutter/cupertino.dart';

class ChatUser {
  String name;
  String messageText;
  String image;
  String time;
  ChatUser(
      {@required this.name,
      @required this.messageText,
      @required this.image,
      @required this.time});
}
