import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/pages/home_page.dart';
import 'package:fluttermyinsta/pages/signin_page.dart';
import 'package:fluttermyinsta/pages/signup_page.dart';
import 'package:fluttermyinsta/pages/splash_page.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _strartPage() {
      return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            Prefs.saveUserId(snapshot.data.uid);
            return Home_page();
          } else {
            Prefs.removeUserId();
            return Signin_page();
          }
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter_myinsta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _strartPage(),
      routes: {
        Splash_page.id: (context) => Splash_page(),
        Signin_page.id: (context) => Signin_page(),
        Signup_page.id: (context) => Signup_page(),
        Home_page.id: (context) => Home_page(),
      },
    );
  }
}
