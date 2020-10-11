import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  final String id;
  final String username;
  final String email;

  Person({
    this.id,
    this.username,
    this.email,
  });

  factory Person.fromDocument(DocumentSnapshot doc) {
    return Person(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
    );
  }
}
