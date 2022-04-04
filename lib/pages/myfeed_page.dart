// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/pages/someone_profile_page.dart';
import 'package:fluttermyinsta/services/data_service.dart';
import 'package:fluttermyinsta/services/untills.dart';
import 'package:share/share.dart';

class Myfeed_page extends StatefulWidget {
  static const String id = "myfeed_page";
  PageController pageController;
  Myfeed_page({ Key? key, required this.pageController}) : super(key: key);
  @override
  _Myfeed_pageState createState() => _Myfeed_pageState();
}

class _Myfeed_pageState extends State<Myfeed_page> {
  List<Post> items = [];
  bool isloading = false;
  //load feed
  void _apiloadfeeds() {
    setState(() {
      isloading = true;
    });
    DataService.loadFeeds().then((value) => {
          _resloadfeed(value),
        });
  }

  void _resloadfeed(List<Post> posts) {
    setState(() {
      isloading = false;
      items = posts;
    });
  }
 //like post
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
//inlike post
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
  //remove post
  _actionremovepost(Post post)async{
    var result =await Utils.dialogCommon(context, "Instagram", "Do you want to remove this post?", false);
    if(result){
      setState(() {
        isloading=true;
      });
      DataService.removePost(post).then((value) => {
        _apiloadfeeds(),
      });
  }}
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
        title: const Text(
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
          //navigate=> createpost page
          IconButton(
            onPressed: () {
              widget.pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
            },
            icon: const Icon(Icons.camera_alt),
            color: const Color.fromRGBO(251, 175, 69, 1),
          ),
        ],
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
                  child: Text("No feeds",style: TextStyle(color: Colors.black26),),
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
          Container(
              padding:const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        // navigate someoneprofile page
                        onTap: () {
                           if (post.mine == false) {
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => SomeoneProfilePage(post:post),
                               ),
                             );
                             if (kDebugMode) {

                               print(post.uid.toString());
                             }
                           }
                        },
                        // user image
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: post.img_user.isEmpty
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
                          // fullname text
                          Text(
                            post.fullname,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          //date
                          Text(
                            post.date!,
                            style:const TextStyle(fontWeight: FontWeight.normal),
                          )
                        ],
                      )
                    ],
                    // more button
                  ),
                  post.mine?
                  IconButton(
                    icon: const Icon(SimpleLineIcons.options),
                    onPressed: () {
                      _actionremovepost(post);
                    },
                  ):const SizedBox.shrink(),
                ],
              )),
          //post image
          Center(
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
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
                  // like button
                  IconButton(
                    onPressed: () {
                      if (!post.liked) {
                        _apipostlike(post);
                      } else {
                        _apipostunlike(post);
                      }
                    },
                    icon: post.liked
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                  ),
                  //share
                  IconButton(
                    onPressed: () {
                      Share.share('Image: ${post.img_post} \n Caption: ${post.caption}');
                    },
                    icon: const Icon(Icons.share_outlined),
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
                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
