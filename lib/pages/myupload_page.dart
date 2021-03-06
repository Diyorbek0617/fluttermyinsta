// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/services/data_service.dart';
import 'package:fluttermyinsta/services/file_service.dart';
import 'package:fluttermyinsta/services/untills.dart';
import "package:image_picker/image_picker.dart" show ImagePicker, ImageSource;

class Myupoad_page extends StatefulWidget {
  // const Myupoad_page({Key key}) : super(key: key);
  static const String id = "myupload_page";
  PageController pageController;
  Myupoad_page({ Key? key, required this.pageController}) : super(key: key);
  @override
  _Myupoad_pageState createState() => _Myupoad_pageState();
}

  File? _image;

class _Myupoad_pageState extends State<Myupoad_page> {
  bool isLoading = false;
  var captioncontroller = TextEditingController();

  // camera
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

// gallery
  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

//upload new post
  _uploadnewpost() {
    String caption = captioncontroller.text.toString().trim();
    if (_image != null && caption != null) {
      _apipostimage();
    } else {
      Utils.fireToast("rasm va izoh bo'sh bo'lmasligi kerak!");
    }
  }

  void _apipostimage() {
    setState(() {
      isLoading = true;
    });
    FileService.uploadPostImage(_image!).then((downloadurl) => {
          _respostimage(downloadurl),
        });
  }

  void _respostimage(String downloadurl) {
    String caption = captioncontroller.text.toString().trim();
    Post post = Post(caption: caption, img_post: downloadurl);
    _apistorepost(post);
  }

  void _apistorepost(Post post) async {
    Post posted = await DataService.storePost(post);
    DataService.storeFeed(posted).then((value) => {
          _movetofeed(),
        });
  }

  void _movetofeed() {
    setState(() {
      isLoading = false;
    });
    widget.pageController.animateToPage(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    _image = null;
    captioncontroller.text = "";
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Upload",
          style: TextStyle(color: Colors.black, fontFamily: "Billabong"),
        ),
        actions: [
          // button : create post
          IconButton(
            onPressed: _uploadnewpost,
            icon: const Icon(Icons.drive_folder_upload_outlined),
            color: const Color.fromRGBO(251, 175, 69, 1),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    // choose image
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      color: const Color.fromRGBO(251, 175, 69, 1)
                          .withOpacity(0.3),
                      child: _image == null
                          ? GestureDetector(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Color.fromRGBO(251, 175, 69, 1),
                                  size: 60,
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                // Added photo
                                SizedBox(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black12.withOpacity(0.2),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          icon: const Icon(
                                            Icons.highlight_remove,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _image = null;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),

                    // #add caption
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: TextField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          hintText: "Caption",
                          hintStyle:
                              TextStyle(color: Colors.black26, fontSize: 18),
                        ),
                        maxLength: 20,
                        controller: captioncontroller,
                      ),
                    ),
                  ],
                ),
              ),
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
}
