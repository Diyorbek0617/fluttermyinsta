import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/model/user_model.dart';
import 'package:fluttermyinsta/services/auth_service.dart';
import 'package:fluttermyinsta/services/data_service.dart';
import 'package:fluttermyinsta/services/file_service.dart';
import 'package:image_picker/image_picker.dart';

class My_profile_page extends StatefulWidget {
  const My_profile_page({Key key}) : super(key: key);
  static final String id = "my_profile_page";

  @override
  _My_profile_pageState createState() => _My_profile_pageState();
}

class _My_profile_pageState extends State<My_profile_page> {
  bool iscorrect = false;
  bool isLoading = false;
  String fullname = "", email = "", img_url = "";
  File _image;
  List<Post> items = new List();
  String img1 =
      "https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost.png?alt=media&token=f0b1ba56-4bf4-4df2-9f43-6b8665cdc964";
  String img2 =
      "https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost2.png?alt=media&token=ac0c131a-4e9e-40c0-a75a-88e586b28b72";
  @override
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
    _apichangephoto();
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
    _apichangephoto();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(0.8),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Pick Photo'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.blue,
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Take Photo'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

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
      isLoading = false;
      this.fullname = user.fullname;
      this.email = user.email;
      this.img_url = user.img_url;
    });
  }

  void _apichangephoto() {
    if (_image == null) return;
    setState(() {
      isLoading = true;
    });
    FileService.uploadUserImage(_image).then((downloadUrl) => {
          _apiUpdateUser(downloadUrl),
        });
  }

  void _apiUpdateUser(String downloadUrl) async {
    User user = await DataService.loadUser();
    setState(() {
      user.img_url = downloadUrl;
    });

    await DataService.updateUser(user);
    setState(() {
      img_url=downloadUrl;
      isLoading = false;
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    items.add(Post(img_post: img1, caption: "Discover more geat images"));
    items.add(Post(img_post: img2, caption: "Discover more geat images"));
    items.add(Post(img_post: img1, caption: "Discover more geat images"));
    items.add(Post(img_post: img2, caption: "Discover more geat images"));
    items.add(Post(img_post: img1, caption: "Discover more geat images"));
    items.add(Post(img_post: img2, caption: "Discover more geat images"));
    items.add(Post(img_post: img1, caption: "Discover more geat images"));
    items.add(Post(img_post: img2, caption: "Discover more geat images"));
    items.add(Post(img_post: img1, caption: "Discover more geat images"));
    items.add(Post(img_post: img2, caption: "Discover more geat images"));
    _apiLoadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: Colors.black, fontFamily: "Billabong", fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOutUser(context);
            },
            icon: Icon(
              Icons.exit_to_app_outlined,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(
                            width: 1.5,
                            color: Color.fromRGBO(192, 53, 132, 1),
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: img_url == null || img_url.isEmpty
                            ? Image(
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
                    Container(
                      width: 80,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Icon(
                              Icons.add_circle_outline_sharp,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  fullname.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  email,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "675",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
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
                              Text(
                                "4.562",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
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
                              Text(
                                "897",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
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
                  margin: EdgeInsets.only(top: 10, bottom: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            iscorrect = false;
                          });
                        },
                        icon: Icon(Icons.list_alt_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            iscorrect = true;
                          });
                        },
                        icon: Icon(Icons.grid_view),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: iscorrect == false
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1),
                          itemCount: items.length,
                          itemBuilder: (ctx, index) {
                            return _itemsofpost(items[index]);
                          },
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemsofpost(Post post) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              imageUrl: post.img_post,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            post.caption,
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
