import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/pages/my_likes_page.dart';
import 'package:fluttermyinsta/pages/my_profile_page.dart';
import 'package:fluttermyinsta/pages/myfeed_page.dart';
import 'package:fluttermyinsta/pages/mysearch_page.dart';
import 'package:fluttermyinsta/pages/myupload_page.dart';
import 'package:fluttermyinsta/services/untills.dart';

class Home_page extends StatefulWidget {
 // const Home_page({required Key? key}) : super(key: key);
  static const String id = "home_page";

  @override
  _Home_pageState createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int _cureenttab = 0;
  late PageController _pageController;

  // nitication of local
  _initNotification() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Utils.showLocalNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume: $message");
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initNotification();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //pageview
      body: PageView(
        controller: _pageController,
        children: [
          Myfeed_page(pageController: _pageController),
          Mysearch_page(),
          Myupoad_page(pageController: _pageController),
          My_likes_page(),
          My_profile_page(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _cureenttab = index;
          });
        },
      ),
      //bottomnavigationbar type of footer
      bottomNavigationBar: CupertinoTabBar(
        inactiveColor: Colors.white,
        backgroundColor: const Color.fromRGBO(252, 175, 69, 1),
        onTap: (int index) {
          setState(() {
            _cureenttab = index;
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn);
          });
        },
        activeColor: Colors.deepOrange,
        currentIndex: _cureenttab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
