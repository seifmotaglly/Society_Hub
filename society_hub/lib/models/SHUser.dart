import 'package:sociaty_hub/constants/ConstantAttributes.dart';
import 'package:sociaty_hub/models/User.dart';

class SHUser {
  final String email;
  final String username;

  SHUser({this.email, this.username}) {
    User.myUser = User(
        username: ConstantAttributes.myName,
        photoUrl: "https://i.ytimg.com/vi/tMkURmaHKgs/maxresdefault.jpg",
        id: username,
        email: email,
        displayName: "",
        bio: "");
  }
}
