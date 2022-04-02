import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/model/user_model.dart';
import 'package:fluttermyinsta/services/auth_service.dart';
import 'package:fluttermyinsta/services/data_service.dart';
import 'package:fluttermyinsta/services/file_service.dart';
import 'package:fluttermyinsta/services/untills.dart';
import 'package:image_picker/image_picker.dart';

class My_profile_page extends StatefulWidget {
  const My_profile_page({ Key? key}) : super(key: key);
  static const String id = "my_profile_page";

  @override
  _My_profile_pageState createState() => _My_profile_pageState();
}

class _My_profile_pageState extends State<My_profile_page> {
  bool iscorrect = false;
  bool isLoading = false;
  String fullname = "", email = "", img_url = "";
  int count_posts=0, count_followers=0,count_following=0;
   File? _image;
  List<Post> items = [];
     // camera
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
    _apichangephoto();
  }
  // gallery
  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
    _apichangephoto();
  }
  // bottomsheet: gallery and camera
  void _showPicker(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(0.8),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Pick Photo'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.blue,
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take Photo'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
  // load user
  _apiLoadUser() {
    setState(() {
      isLoading = true;
    });
    DataService.loadUser().then((value) => {
          _showUserInfo(value),
        });

    _apichangephoto();
  }
  _showUserInfo(User user) {
    setState(() {
      this.fullname = user.fullname;
      this.email = user.email;
      this.img_url = user.img_url;
      this.count_followers=user.fallowers_count;
      this.count_following=user.fallowing_count;
      isLoading = false;
    });
  }
  // change photo
  void _apichangephoto() {
    if (_image == null) return;
    setState(() {
      isLoading = true;
    });
    FileService.uploadUserImage(_image!).then((downloadUrl) => {
          _apiUpdateUser(downloadUrl),
        });
  }
   // upgrade user image
  void _apiUpdateUser(String? downloadUrl) async {
    User user = await DataService.loadUser();
    setState(() {
      user.img_url = downloadUrl!;
    });

    await DataService.updateUser(user);
    setState(() {
      img_url=downloadUrl!;
      isLoading = false;
    });
  }
  // load post
  void _apiloadposts(){
    DataService.loadPosts().then((value){
      _resloadposts(value);
    });
  }
  void _resloadposts(List<Post>posts){
    setState(() {
      items=posts;
      count_posts =items.length;
    });
  }
  // user log out
  _actionlogout()async{
    var result =await Utils.dialogCommon(context, "Instagram", "Do you want to log out?", false);
    if(result!=null&&result){
      AuthService.signOutUser(context);
    }

  }
  // remove post
  Future _actionremovepost(Post post)async{
    var result = await Utils.dialogCommon(context, "Instagram", "Do you want to remove this post?", false);
    if(result!=null&& result){
      setState(() {
        isLoading=true;
      });
      DataService.removePost(post).then((value) => {
        _apiLoadUser(),
      });
    }}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadUser();
    _apiloadposts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.black, fontFamily: "Billabong", fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          // log out button
          IconButton(
            onPressed: () {
              _actionlogout();

            },
            icon: const Icon(
              Icons.exit_to_app_outlined,
              color:  Color.fromRGBO(251, 175, 69, 1),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(
                            width: 1.5,
                            color:const Color.fromRGBO(192, 53, 132, 1),
                          )),
                      // user image
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: img_url == null || img_url.isEmpty
                            ? const Image(
                                image:
                                    AssetImage("assets/images/ic_person.png"),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                img_url,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // button camera and gallery
                          GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: const Icon(
                              Icons.add_circle_outline_sharp,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // profile name
                Text(
                  fullname.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                // profile email
                Text(
                  email,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // count posts
                              Text(
                                count_posts.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              // post title
                              const Text(
                                "Post",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // count followers
                              Text(
                                count_followers.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              // followers title
                              const Text(
                                "Followers",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // count following
                              Text(
                                count_following.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              // following title
                              const Text(
                                "Following",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // listview button
                      IconButton(
                        onPressed: () {
                          setState(() {
                            iscorrect = false;
                          });
                        },
                        icon: const Icon(Icons.list_alt_outlined),
                      ),
                      // gridview button
                      IconButton(
                        onPressed: () {
                          setState(() {
                            iscorrect = true;
                          });
                        },
                        icon: const Icon(Icons.grid_view),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 1,),
                Expanded(
                  child:items.isEmpty?const Center(child: Text("No Post",style: TextStyle(color: Colors.black26),),): iscorrect == false
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1),
                          itemCount: items.length,
                          itemBuilder: (ctx, index) {
                            return _itemsofpost(items[index]);
                          },
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: items.length,
                          itemBuilder: (ctx, index) {
                            return _itemsofpost(items[index]);
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
   //body: widget
  Widget _itemsofpost(Post post) {
    return GestureDetector(
      onLongPress: (){
        _actionremovepost(post);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              //post image
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                imageUrl: post.img_post,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
           iscorrect==false? Text(
              post.caption,
              style: const TextStyle(color: Colors.black87, fontSize: 9),
              softWrap: true,
            ):const SizedBox.shrink(),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
