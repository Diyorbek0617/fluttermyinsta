import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/pages/someone_profile_page.dart';
import 'package:fluttermyinsta/services/data_service.dart';
import 'package:fluttermyinsta/services/untills.dart';
import 'package:share/share.dart';

class My_likes_page extends StatefulWidget {
  const My_likes_page({ Key? key}) : super(key: key);
  static const String id = "my_likes_page";

  @override
  _My_likes_pageState createState() => _My_likes_pageState();
}

class _My_likes_pageState extends State<My_likes_page> {
  List<Post> items = [];
  bool isloading = false;
  // load likes
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

//  unlike post
  void _apipostunlike(Post post) async {
    setState(() {
      isloading = true;
      post.liked = false;
    });
    await DataService.likePost(post, false);
    _apiloadLikes();
  }

// remove post
  _actionremovepost(Post post) async {
    var result = await Utils.dialogCommon(
        context, "Instagram", "Do you want to remove this post?", false);
    if (result != null && result) {
      setState(() {
        isloading = true;
      });
      DataService.removePost(post).then((value) => {
            _apiloadLikes(),
          });
    }
  }

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
        title: const Text(
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
      // body: listview
      body: Stack(
        children: [
          items.isNotEmpty
              ? ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _itemsofPost(items[index]);
                  },
                )
              : const Center(
                  child: Text(
                    "No liked posts",
                    style: TextStyle(color: Colors.black26),
                  ),
                ),
          isloading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  // body: widget
  Widget _itemsofPost(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          // Profile information
          Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile information
                  Row(
                    children: [
                      // Profile image
                      GestureDetector(
                        onTap: () {
                          if (post.mine == false) {
                            // someone profile navigate
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SomeoneProfilePage(
                                  uid: post.uid,
                                ),
                              ),
                            );
                          }
                        },
                        // user image
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: post.img_user == null || post.img_user.isEmpty
                              ? const Image(
                                  image:
                                      AssetImage("assets/images/ic_person.png"),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  post.img_user,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // user name
                          Text(
                            post.fullname,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          // post time
                          Text(
                            post.date!,
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                          )
                        ],
                      )
                    ],
                  ),
                  //more button
                  post.mine
                      ? IconButton(
                          icon: const Icon(SimpleLineIcons.options),
                          onPressed: () {
                            _actionremovepost(post);
                          },
                        )
                      : const SizedBox.shrink(),
                ],
              )),
          // post image
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: post.img_post,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
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
                      if (post.liked) {
                        _apipostunlike(post);
                      }
                    },
                    // post like
                    icon: post.liked
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                  ),
                  // post share
                  IconButton(
                    onPressed: () {
                      Share.share(
                          'Image: ${post.img_post} \n Caption: ${post.caption}');
                    },
                    icon: const Icon(Icons.share),
                  ),
                ],
              ),
            ],
          ),
          // post caption
          Container(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              post.caption,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
