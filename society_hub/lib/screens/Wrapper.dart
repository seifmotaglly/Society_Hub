import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sociaty_hub/models/SHUser.dart';
import 'package:sociaty_hub/screens/WelcomeScreen.dart';
import 'package:sociaty_hub/widgets/bottombar/bottombar.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SHUser>(context);
    print(user);

    if (user == null) {
      print("goint to Welcome Screen");
      return WelcomeScreen();
    } else {
      print("going to home Screen");
      return BottomBar();
    }
  }
}
