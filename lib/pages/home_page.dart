
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/pages/my_likes_page.dart';
import 'package:fluttermyinsta/pages/my_profile_page.dart';
import 'package:fluttermyinsta/pages/myfeed_page.dart';
import 'package:fluttermyinsta/pages/mysearch_page.dart';
import 'package:fluttermyinsta/pages/myupload_page.dart';


class Home_page extends StatefulWidget {
   Home_page({Key key}) : super(key: key);
  static final String id="home_page";

  @override
  _Home_pageState createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
   int _cureenttab=0;
   PageController _pageController;


   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  PageView(
        controller: _pageController,
        children:  [
          Myfeed_page(pageController: _pageController),
          Mysearch_page(),
          Myupoad_page(pageController: _pageController),
          My_likes_page(),
          My_profile_page(),

        ],
          onPageChanged: (int index){
          setState(() {
            _cureenttab=index;
          });
    },
      ),
      bottomNavigationBar: CupertinoTabBar(
        inactiveColor: Colors.white,
        backgroundColor:Color.fromRGBO(252, 175, 69, 1),
        onTap: (int index){
          setState(() {
            _cureenttab=index;
            _pageController.animateToPage(index,duration:Duration(milliseconds: 200),curve: Curves.easeIn);
          });
        },
        activeColor: Colors.deepOrange,
        currentIndex: _cureenttab,
        items: [
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
