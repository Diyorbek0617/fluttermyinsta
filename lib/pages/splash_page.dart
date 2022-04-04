// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/pages/home_page.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';

class Splash_page extends StatefulWidget {
 // const Splash_page({required Key key}) : super(key: key);
  static final String id = "splash_page";

  @override
  _Splash_pageState createState() => _Splash_pageState();
}

class _Splash_pageState extends State<Splash_page> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // timer navigate=> home page
  initTimer() {
    Timer(const Duration(seconds: 2), () {
      callSinglepage();
    });
  }

  callSinglepage() {
    Navigator.pushReplacementNamed(context, Home_page.id);
  }
  // notification
  _initNotification() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print(token);
      Prefs.saveFCM(token!);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTimer();
    _initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(252, 175, 69, 1),
                Color.fromRGBO(245, 96, 64, 1),
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Expanded(
              child: Center(
                child: Text(
                  "Instagram",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontFamily: "Billabong"),
                ),
              ),
            ),
            Text(
              "All right resered",
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
