import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/services/data_service.dart';

class Myfeed_page extends StatefulWidget {
  // const Myfeed_page({Key key}) : super(key: key);
  static final String id = "myfeed_page";
  PageController pageController;
  Myfeed_page({this.pageController});
  @override
  _Myfeed_pageState createState() => _Myfeed_pageState();
}

class _Myfeed_pageState extends State<Myfeed_page> {
  List<Post> items = new List();
  bool isloading = false;
  void _apiloadfeeds() {
    DataService.loadFeeds().then((value) => {
          _resloadfeed(value),
        });
  }

  void _resloadfeed(List<Post> posts) {
    setState(() {
      items = posts;
    });
  }

  void _apipostlike(Post post) async {
    setState(() {
      isloading = true;
    });
    await DataService.likePost(post, true);
    setState(() {
      isloading = false;
      post.liked = true;
    });
  }

  void _apipostunlike(Post post) async {
    setState(() {
      isloading = true;
    });
    await DataService.likePost(post, false);
    setState(() {
      isloading = false;
      post.liked = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiloadfeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Instagram",
          style: TextStyle(
            fontFamily: "Billabong",
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              widget.pageController.animateToPage(2,
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
            icon: Icon(Icons.camera_alt),
            color: Color.fromRGBO(251, 175, 69, 1),
          ),
        ],
      ),
      body: Stack(
        children: [
          items.length > 0
              ? ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _itemsofPost(items[
                        index]); //:Center(child: Text("Feedlar mavjud emas."),);
                  },
                )
              : Center(
                  child: Text("No feeds"),
                ),
          isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemsofPost(Post post) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image(
                          image: AssetImage("assets/images/ic_person.png"),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.fullname,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            post.date,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          )
                        ],
                      )
                    ],
                  ),
                  IconButton(
                    icon: const Icon(SimpleLineIcons.options),
                    onPressed: () {},
                  ),
                ],
              )),
          Center(
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              imageUrl: post.img_post,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (!post.liked) {
                        _apipostlike(post);
                      } else {
                        _apipostunlike(post);
                      }
                    },
                    icon: post.liked
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                          ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.share_outlined),
                  ),
                ],
              ),
            ],
          ),
          Text(
            post.caption,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
