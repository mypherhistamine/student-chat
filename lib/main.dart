import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:studlife_chat/auth/changeNotifiers/AuthService.dart';
import 'package:studlife_chat/auth/wrapper.dart';
import 'package:studlife_chat/screens/register.dart';

import 'auth/changeNotifiers/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserManage()),
        ChangeNotifierProvider.value(value: AuthService())
      ],
      child: MaterialApp(
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
        home: RegisterUserPage(),
      ),
    );
  }
}
