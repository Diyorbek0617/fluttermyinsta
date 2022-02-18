import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/pages/home_page.dart';
import 'package:fluttermyinsta/pages/signin_page.dart';
import 'package:fluttermyinsta/services/auth_service.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';
import 'package:fluttermyinsta/untills.dart';

class Signup_page extends StatefulWidget {
  const Signup_page({Key key}) : super(key: key);
  static final String id="signup_page";

  @override
  _Signup_pageState createState() => _Signup_pageState();
}

class _Signup_pageState extends State<Signup_page> {
  bool isloading=false;
  var fullnamecontroller=TextEditingController();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var confirmcontroller=TextEditingController();
  _dosign_up(){
    String name=fullnamecontroller.text.toString().trim();
    String email=emailcontroller.text.toString().trim();
    String password=passwordcontroller.text.toString().trim();
    String cpassword=confirmcontroller.text.toString().trim();
    var email_vaidation = RegExp(r"^[A-z0-9.A-z0-9.!$%&'*+-/=?^_`{|}~]+@(g|e|G|E)mail+\.[A-z]+").hasMatch(email);
    var password_vaidation = RegExp(r"^(?=.*[0-9])(?=.*[A-Z])(?=.*[.!#$@%&'*+/=?^_`{|}~-]).{8,}$").hasMatch(password);
    if(name.isEmpty||email_vaidation|| password_vaidation||cpassword.isEmpty)return;
    if(password!=cpassword){
      Utils.fireToast("password or confirm password does not match");
      return;
    }
    setState(() {
      isloading=true;
    });
    AuthService.signUpUser(context, name, email, password).then((firebaseUser) =>
    {
      _getfirebaseUser(firebaseUser),
    });
  }
  _getfirebaseUser(FirebaseUser firebaseUser)async{
    setState(() {
      isloading=false;
    });
    if(firebaseUser!=null){
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, Home_page.id);
    }
    else{
      Utils.fireToast("Check your information");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
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
                        Center(
                          child: Text(
                            "Instagram",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontFamily: "Nottingsam_Demo"),
                          ),
                        ),
                        SizedBox(
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
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: fullnamecontroller,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Fullname",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
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
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller:emailcontroller,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
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
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: passwordcontroller,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Password",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
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
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: confirmcontroller,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                  // #Sign in button
                        GestureDetector(
                          onTap: (){
                            _dosign_up();
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            margin: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white54.withOpacity(0.2),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(color: Colors.white, fontSize: 17),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: _callSignInPage,
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              isloading?
              Center(
                child: CircularProgressIndicator(),
              ):SizedBox.shrink(),
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
