import 'package:firebase_auth/firebase_auth.dart';
import 'package:sociaty_hub/models/SHUser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SHUser SHUserFromFirebaseUser(User user) {
    return user != null ? SHUser(email: user.email, userID: user.uid) : null;
  }

  Stream<SHUser> get user {
    return _auth.authStateChanges().map((SHUserFromFirebaseUser));
  }

  Future signIn(String email, String password) async {
    print("this from sign in");
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return SHUserFromFirebaseUser(user);
    } catch (e) {
      print("in catch");
      print(e.toString());
      return null;
    }
  }

  Future signUp(String userName, String email, String password) async {
    print("this from sign up");
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return SHUserFromFirebaseUser(user);
    } catch (e) {
      print("in catch");
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
