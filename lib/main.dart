import 'package:flutter/material.dart';
import 'package:studlife_chat/screens/AuthScreen.dart';

// timport 'package:studlife_chat/screens/authScreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: AuthScreen(),
    );
  }
}
