import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../provider/user.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> _formState = GlobalKey();

  String email, password;
  bool isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final StorageReference storageRef = FirebaseStorage.instance.ref();
  final usersRef = Firestore.instance.collection('users');
  bool isAuth;
  Person currentUser;
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   await Firebase.initializeApp();
    // });

    // pageController = PageController();
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      // createUserInFirestore();
      final GoogleSignInAccount user = googleSignIn.currentUser;
      DocumentSnapshot doc = await usersRef.document(user.id).get();

      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore({String username}) async {
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page

      // 3) get username from create account, use it to make new user document in users collection

      // local file of user *******
      // usersRef.document(user.id).setData({
      //   "id": user.id,
      //   "username": username,
      // });

      doc = await usersRef.document(user.id).get();
    }

    currentUser = Person.fromDocument(doc);
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Form(
              key: _formState,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Welcome to SRM\nQuestion Bank App",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Login For Teachers"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 300,
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (v) {
                            this.email = v;
                          },
                          validator: (value) {
                            bool isEmailValid = RegExp(
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                .hasMatch(value);
                            if (!isEmailValid)
                              return "Email is not properly formatted";
                          },
                          decoration: InputDecoration(hintText: "email"),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40)
                          ],
                        ),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(hintText: "password"),
                        obscureText: true,
                        onChanged: (v) {
                          this.password = v;
                        },
                        validator: (value) {
                          if (value.length < 6)
                            return "Password has to be atleast 6 characters long";
                        },
                      ),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () async {
                        if (_formState.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          // var result = await getIt<TeacherAuth>().login(email, password);
                          var result = false;

                          if (!result) {
                            _showErrorDialog(context);
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                      child: Text("Sign In"),
                      color: Colors.blueAccent,
                      textColor: Colors.white70,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      login();
                      // Navigator.pushNamed(context, '/listSubjects');
                    },
                    child: Text("Sign In with Gmail"),
                    color: Colors.amberAccent,
                    textColor: Colors.black38,
                  )
                ],
              ),
            ),
          ),
          (isLoading)
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                      color: Colors.black54,
                      child: Center(
                          child: Loading(
                              indicator: BallGridPulseIndicator(),
                              color: Colors.amberAccent))))
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  _showErrorDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Failed to autenticate, try again"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "close",
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
