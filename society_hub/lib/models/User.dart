import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String displayName;
  final String photoUrl;
  final String bio;

  User(
      {this.id,
      this.username,
      this.photoUrl,
      this.email,
      this.displayName,
      this.bio});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc.get('id'),
        username: doc.get('name'),
        email: doc.get('email'),
        displayName: doc.get('displayName'),
        photoUrl: doc.get('photoUrl'),
        bio: doc.get('bio'));

    // id: doc.data['id'],
    // username: doc.data()['name'],
    // email: doc.data()['email'],
    // displayName: doc.data()['displayName'],
    // photoUrl: doc.data()['photoUrl'],
    // bio: doc.data();
  }
}
