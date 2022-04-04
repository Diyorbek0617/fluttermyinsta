// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/pages/home_page.dart';
import 'package:fluttermyinsta/pages/signup_page.dart';
import 'package:fluttermyinsta/services/auth_service.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';
import 'package:fluttermyinsta/services/untills.dart';

class Signin_page extends StatefulWidget {
  //const Signin_page({required Key key}) : super(key: key);
  static const String id = "signin_page";

  @override
  _Signin_pageState createState() => _Signin_pageState();
}

class _Signin_pageState extends State<Signin_page> {
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  // login
  _dosign_in() {
    String email = emailcontroller.text.toString().trim();
    String password = passwordcontroller.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;

    AuthService.signInUser(context, email, password).then((value) => {
          _getfirebaseUser(value),
        });
  }

  // check firebase user
  _getfirebaseUser(Map<String, FirebaseUser> map) async {
    FirebaseUser firebaseUser;
    if (!map.containsKey("SUCCES")) {
      if (map.containsKey("ERROR_EMAIL_ALREADY_IN_USE")) {
        Utils.fireToast("Email already in user");
      }
      if (map.containsKey("ERROR")) {
        Utils.fireToast("Check email or password");
      }
    }
    firebaseUser = map["SUCCESS"]!;

    // ignore: unnecessary_null_comparison
    if (firebaseUser != null) {
      print(map);
      Navigator.pushReplacementNamed(context, Home_page.id);
      await Prefs.saveUserId(firebaseUser.uid);
    } else {
      Utils.fireToast("Check your email or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(252, 175, 69, 1),
                Color.fromRGBO(245, 96, 64, 1),
              ],
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // #instagram title
                        const Center(
                          child: Text(
                            "Instagram",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontFamily: "Nottingsam_Demo"),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // // #Email textfied
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white54.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
// #Password textfield
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white54.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: passwordcontroller,
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Password",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
// #Sign in button
                        GestureDetector(
                          onTap: _dosign_in,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white54.withOpacity(0.2),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Center(
                                child: Text(
                              "Sign in",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account",
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        //navigate=>sign up page
                        onTap: _callSignUpPage,
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// navigate=>sign up page
  _callSignUpPage() {
    Navigator.pushReplacementNamed(context, Signup_page.id);
  }
}
