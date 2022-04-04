// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/model/user_model.dart';
import 'package:fluttermyinsta/pages/home_page.dart';
import 'package:fluttermyinsta/pages/signin_page.dart';
import 'package:fluttermyinsta/services/auth_service.dart';
import 'package:fluttermyinsta/services/data_service.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';
import 'package:fluttermyinsta/services/untills.dart';

class Signup_page extends StatefulWidget {
//  const Signup_page({required Key key}) : super(key: key);
  static const String id = "signup_page";

  @override
  _Signup_pageState createState() => _Signup_pageState();
}

class _Signup_pageState extends State<Signup_page> {
  bool isloading = false;
  var fullnamecontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var confirmcontroller = TextEditingController();
  // sign up
  _dosign_up() {
    String name = fullnamecontroller.text.toString().trim();
    String email = emailcontroller.text.toString().trim();
    String password = passwordcontroller.text.toString().trim();
    String cpassword = confirmcontroller.text.toString().trim();
    var emailVaidation =
        RegExp(r"^[A-z0-9.A-z0-9.!$%&'*+-/=?^_`{|}~]+@(g|e|G|E)mail+\.[A-z]+")
            .hasMatch(email);
    var passwordVaidation =
        RegExp(r"^(?=.*[0-9])(?=.*[A-Z])(?=.*[.!#$@%&'*+/=?^_`{|}~-]).{8,}$")
            .hasMatch(password);
    if (name.isEmpty || email.isEmpty || password.isEmpty || cpassword.isEmpty)
      return;
    if (password != cpassword) {
      Utils.fireToast("password or confirm password does not match");
      return;
    }
    setState(() {
      isloading = true;
    });

    User user = User(fullname: name, email: email, password: password);
    AuthService.signUpUser(context, name, email, password).then((map) => {
          _getfirebaseUser(user, map),
        });
  }

  // check firebase user
  _getfirebaseUser(User user, Map<String, FirebaseUser> map) async {
    FirebaseUser firebaseUser;
    if (!map.containsKey("SUCCES")) {
      if (map.containsKey("ERROR_EMAIL_ALREADY_IN_USE")) {
        Utils.fireToast("Email already in user");
      }
      if (map.containsKey("ERROR")) {
        Utils.fireToast("Try again later");
      }
    }
    firebaseUser = map["SUCCESS"]!;
    if (firebaseUser != null) {
      print(map);
      await Prefs.saveUserId(firebaseUser.uid);
      DataService.storeUser(user).then((value) => {
            Navigator.pushReplacementNamed(context, Home_page.id),
            setState(() {
              isloading = false;
            }),
          });
    } else {
      Utils.fireToast("Check your information");
      setState(() {
        isloading = false;
      });
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
                        // #Fullname textfied
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
                            controller: fullnamecontroller,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Fullname",
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
                        // #Email textfield
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
                        // #Password textfied
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
                        // #ConfirmPassword textfield
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
                            controller: confirmcontroller,
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Confirm Password",
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
                          onTap: () {
                            _dosign_up();
                          },
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
                              "Sign up",
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
                        "Already have an account",
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: _callSignInPage,
                        child: const Text(
                          "Sign in",
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
              isloading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  _callSignInPage() {
    Navigator.pushReplacementNamed(context, Signin_page.id);
  }
}
