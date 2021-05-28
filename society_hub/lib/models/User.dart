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
    Map<String, dynamic> data = doc.data();
    return User(
        id: data['id'],
        username: data['name'],
        email: data['email'],
        displayName: data['display_name'],
        photoUrl: data['photo_url'],
        bio: data['bio']);
  }
}
