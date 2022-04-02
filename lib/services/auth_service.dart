import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/model/user_model.dart';
import 'package:fluttermyinsta/pages/signin_page.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
//Authication sign in
  static Future<Map<String, FirebaseUser>> signInUser(
      BuildContext context, String email, String password) async {
    Map<String, FirebaseUser> map = {};
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      final FirebaseUser firebaseUser = await _auth.currentUser();
      print(firebaseUser.toString());
      map.addAll({"SUCCESS": firebaseUser});
    } catch (error) {
      print(error);
      map.addAll({"ERROR": null!});
    }
    return map;
  }
//Authication sign up
  static Future<Map<String, FirebaseUser>> signUpUser(
      BuildContext context, String name, String email, String password) async {
    Map<String, FirebaseUser> map = {};
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      map.addAll({"SUCCESS": firebaseUser});
      print(map);
    } catch (error) {
      print(error);
      switch (error) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          map.addAll({"ERROR_EMAIL_ALREADY_IN_USE": null!});
          break;
        default:
          map.addAll({"ERROR": null!});
      }
    }
    return map;
  }
// Authication  sign out
  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId().then((value) {
      Navigator.pushReplacementNamed(context, Signin_page.id);
    });
  }
}
