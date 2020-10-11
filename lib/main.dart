import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studlife_chat/screens/AuthScreen.dart';

// timport 'package:studlife_chat/screens/authScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QB Chat',
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.amberAccent,
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'PS',
            ),
        primaryTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'PS',
            ),
        accentTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'PS',
            ),
      ),
      home: SignUpPage(),
    );
  }
}
