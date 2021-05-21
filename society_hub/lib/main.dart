import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociaty_hub/models/SHUser.dart';
import 'package:sociaty_hub/screens/Wrapper.dart';
import 'package:sociaty_hub/services/Auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SociatyHub(),
  ));
}

class SociatyHub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<SHUser>.value(
        initialData: null,
        value: AuthService().user,
        child: MaterialApp(debugShowCheckedModeBanner: false, home: Wrapper()));
  }
}
