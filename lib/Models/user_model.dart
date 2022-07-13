import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String uid;

  UserModel({required this.email, required this.uid});

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    return UserModel(
      email: snapshot['email'],
      uid: snapshot['uid'],
    );
  }
}
