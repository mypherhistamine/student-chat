import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';

import 'changeNotifiers/AuthService.dart';

class VerifyUserPage extends StatefulWidget {
  final String title;

  VerifyUserPage({this.title});

  @override
  _VerifyUserPageState createState() => _VerifyUserPageState();
}

class _VerifyUserPageState extends State<VerifyUserPage> {
  String verifiedText = "You're not verified";
  bool sent = false;

  Timer _timer;
  StreamController<bool> isVerifiedStreamController = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    // ... any code here ...
    Future(() async {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        await FirebaseAuth.instance.currentUser()
          ..reload();
        var user = await FirebaseAuth.instance.currentUser();
        print("checking : ${user.isEmailVerified}");
        if (user.isEmailVerified) {
          timer.cancel();
          isVerifiedStreamController.add(true);
        }
      });
    });
  }

  dynamic timestampLastEmailSent;

  String title = "Verification";
  @override
  Widget build(BuildContext context) {
    void goBackToMain() {
      SchedulerBinding.instance.addPostFrameCallback((c) {
        Navigator.of(context).pushReplacementNamed('/rooms');
      });
    }

    isVerifiedStreamController.stream.listen((data) {
      SchedulerBinding.instance.addPostFrameCallback((c) {
        if (data) goBackToMain();
      });
    });

    final AuthService _auth = AuthService();
    return ChangeNotifierProvider(
      child: Center(
            child: Consumer<AuthService>(
              builder: (BuildContext context, AuthService value, Widget child) {
                _auth.getUser;
                if (value.currentUser == null)
                  return Text("Going to verify the user here");
                else if (value.currentUser.isEmailVerified) {
                  goBackToMain();
                  return Text("Your email is verified");
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(verifiedText),
                      RaisedButton(
                        onPressed: () async {
                          dynamic timestampCurrent =
                              new DateTime.now().millisecondsSinceEpoch;
                          if (timestampLastEmailSent != null &&
                              timestampCurrent - timestampLastEmailSent <
                                  120000) {
                            setState(() {
                              verifiedText =
                                  "Please wait a couple minutes before re-sending verification mail";
                            });
                            return;
                          } else {
                            bool result = await _auth.sendVerificationLink();

                            timestampLastEmailSent =
                                new DateTime.now().millisecondsSinceEpoch;

                            if (result) {
                              print("Email verification sent");
                              setState(() {
                                verifiedText = "Email verification sent. Click the link in your email and check back here.";
                                sent = true;
                              });
                            } else {
                              print("Error");
                              setState(() => verifiedText =
                                  "There was an error sending the link. Try again later.");
                            }
                          }
                        },
                        child: Text("Verify your email now"),
                      ),
                      sent ? Loading() : SizedBox.shrink()
                    ],
                  );
                }
              },
            ),
          ),
      create: (BuildContext context) => _auth,
    );
  }
}
