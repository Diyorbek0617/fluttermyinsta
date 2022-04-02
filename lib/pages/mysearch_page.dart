import 'package:flutter/material.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/model/user_model.dart';
import 'package:fluttermyinsta/pages/someone_profile_page.dart';
import 'package:fluttermyinsta/services/data_service.dart';

class Mysearch_page extends StatefulWidget {
  const Mysearch_page({ Key? key}) : super(key: key);
  static const String id = "mysearch_page";

  @override
  _Mysearch_pageState createState() => _Mysearch_pageState();
}

class _Mysearch_pageState extends State<Mysearch_page> {
  var searchcontroller = TextEditingController();
  bool isLoading = false;
  List<User> items = [];
  // search user
  void _apisearchuser(String? keyword) {
    setState(() {
      isLoading = true;
    });
    DataService.searchUsers(keyword!).then((users) => {
          _ressearchusers(users),
        });
  }

  void _ressearchusers(List<User>? users) {
    setState(() {
      items = users!;
      isLoading = false;
    });
  }

  // follow user
  void _apifallowuser(User someone) async {
    setState(() {
      isLoading = true;
    });
    await DataService.fallowUser(someone);
    setState(() {
      someone.fallowed = true;
      isLoading = false;
    });
    DataService.storePostsToMyFeed(someone);
  }

// unfolllow user
  void _apiunfallowuser(User someone) async {
    setState(() {
      isLoading = true;
    });
    await DataService.unfallowUser(someone);
    setState(() {
      someone.fallowed = false;
      isLoading = false;
    });
    DataService.removePostsFromMyFeed(someone);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apisearchuser("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Search",
          style: TextStyle(
              color: Colors.black, fontFamily: "Billabong", fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                // search
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  height: 45,
                  child: TextField(
                    controller: searchcontroller,
                    decoration: const InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (input) {
                      _apisearchuser(input);
                    },
                  ),
                ),
                // body:llistview
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, index) {
                      return _itemofuser(
                        items[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
 //body:widget
  Widget _itemofuser(User user,) {
    return SizedBox(
      height: 90,
      child: Row(
        children: [
          // navigate=>someoneprofile
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SomeoneProfilePage(uid: post.uid,),
              //   ),
              // );
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                  border: Border.all(
                    width: 1.5,
                    color: const Color.fromRGBO(192, 53, 132, 1),
                  )),
              // user image
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: user.img_url.isEmpty
                    ? const Image(
                        image: AssetImage("assets/images/ic_person.png"),
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        user.img_url,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // text user name
              Text(
                user.fullname,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
              const SizedBox(
                height: 3,
              ),
              // text user email
              Text(
                user.email,
                style: const TextStyle(color: Colors.black54, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(
            width: 2,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // follow and unfollow button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (user.fallowed) {
                        _apiunfallowuser(user);
                      } else {
                        _apifallowuser(user);
                      }
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user.fallowed ? "Fallowing" : "Fallow",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
