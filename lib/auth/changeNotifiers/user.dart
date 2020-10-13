import 'package:flutter/cupertino.dart';

class User {
  String name;
  String email;
  String id;

  User({this.email, this.id, this.name});
}

// Logged in user info

User user;

class UserManage with ChangeNotifier {
  void getUser({user}) {
    user = User(email: user.email, name: user.displayName, id: user.uid);
  }
}
