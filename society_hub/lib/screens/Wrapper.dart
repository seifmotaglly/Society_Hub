import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sociaty_hub/constants/ConstantAttributes.dart';
import 'package:sociaty_hub/constants/ConstantFunctions.dart';
import 'package:sociaty_hub/models/SHUser.dart';
import 'package:sociaty_hub/screens/WelcomeScreen.dart';
import 'package:sociaty_hub/services/AuthService.dart';
import 'package:sociaty_hub/widgets/bottombar/bottombar.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SHUser>(context);
    print("This is th user");
    print(user);

    if (user == null) {
      print("goint to Welcome Screen");
      return WelcomeScreen();
    } else {
      setName();
      print("going to hom11e Screen");
      return BottomBar();
    }
  }
}

setName() async {
  ConstantAttributes.myName = await ConstantFunctions.getUserName();
}
