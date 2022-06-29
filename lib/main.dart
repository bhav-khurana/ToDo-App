import 'package:flutter/material.dart';
import 'package:todo_app/authenticate/login.dart';
import 'package:todo_app/authenticate/register.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/pages/profile.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Marcellus',
        ),
        initialRoute: '/login',
        routes: {
          '/register': (context) =>  const Register(),
          '/login':(context) =>  const Login(),
          '/home': (context) => const Home(),
          '/profile': (context) => const Profile(),
        }
    ),
  );
}