import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/services/data_service.dart';
import 'package:fluttermyinsta/services/untills.dart';

class My_likes_page extends StatefulWidget {
  const My_likes_page({Key key}) : super(key: key);
  static final String id = "my_likes_page";

  @override
  _My_likes_pageState createState() => _My_likes_pageState();
}

class _My_likes_pageState extends State<My_likes_page> {
  List<Post> items = new List();
  bool isloading = false;

  void _apiloadLikes() {
    setState(() {
      isloading = true;
    });
    DataService.loadLikes().then((value) => {
          _resloadLike(value),
        });
  }

  void _resloadLike(List<Post> posts) {
    setState(() {
      items = posts;
      isloading = false;
    });
  }
  void _apipostunlike(Post post) async {
    setState(() {
      isloading = true;
      post.liked = false;
    });
    await DataService.likePost(post, false);
   _apiloadLikes();
  }
  _actionremovepost(Post post)async{
    var result =await Utils.dialogCommon(context, "Instagram", "Do you want to remove this post?", false);
    if(result!=null&&result){
      setState(() {
        isloading=true;
      });
      DataService.removePost(post).then((value) => {
        _apiloadLikes(),
      });
    }}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiloadLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Likes",
          style: TextStyle(
            fontFamily: "Billabong",
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          items.length > 0
              ? ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _itemsofPost(items[index]);
                  },
                )
              : Center(
                  child: Text("No liked posts",style: TextStyle(color: Colors.black26),),
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
                  ), post.mine?
                  IconButton(
                    icon: const Icon(SimpleLineIcons.options),
                    onPressed: () {
                      _actionremovepost(post);
                    },
                  ):SizedBox.shrink(),
                ],
              )),
          // Image.network(post.postImage,fit: BoxFit.cover,),
          Center(
            child: CachedNetworkImage(
              imageUrl: post.img_post,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (post.liked) {
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
                    icon: Icon(Icons.share),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              post.caption,
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
