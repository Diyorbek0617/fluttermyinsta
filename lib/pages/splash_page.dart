import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttermyinsta/pages/signin_page.dart';

class Splash_page extends StatefulWidget {
  const Splash_page({Key key}) : super(key: key);
  static final String id = "splash_page";

  @override
  _Splash_pageState createState() => _Splash_pageState();
}

class _Splash_pageState extends State<Splash_page> {
  initTimer() {
    Timer(Duration(seconds: 2), () {
      callSinglepage();
    });
  }

  callSinglepage() {
    Navigator.pushReplacementNamed(context, Signin_page.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
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
          children: [
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
