import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttermyinsta/pages/home_page.dart';
import 'package:fluttermyinsta/pages/signin_page.dart';
import 'package:fluttermyinsta/pages/signup_page.dart';
import 'package:fluttermyinsta/pages/someone_profile_page.dart';
import 'package:fluttermyinsta/pages/splash_page.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';
import 'package:fluttermyinsta/model/post_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // notification
  var initAndroidSetting =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = const IOSInitializationSettings();
  var initSetting =
      InitializationSettings(android: initAndroidSetting, iOS: initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting);
  // don't change  application portrait
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp( MyApp());
  });
}

class MyApp extends StatelessWidget {


  //const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _startPage() {
      return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            Prefs.saveUserId(snapshot.data!.uid);
            return Splash_page();
          } else {
            Prefs.removeUserId();
            return  Signin_page();
          }
        },
      );
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fluttermyinsta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _startPage(),
      // routes
      routes: {
        Splash_page.id: (context) =>  Splash_page(),
        Signin_page.id: (context) =>  Signin_page(),
        Signup_page.id: (context) =>  Signup_page(),
        Home_page.id: (context) =>  Home_page(),
        SomeoneProfilePage.id: (context) => SomeoneProfilePage(),
      },
    );
  }
}
