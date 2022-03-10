import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/services/untills.dart';
import "package:image_picker/image_picker.dart" show ImagePicker, ImageSource;

class Myupoad_page extends StatefulWidget {
  // const Myupoad_page({Key key}) : super(key: key);
  static const String id = "myupload_page";
  PageController pageController;
  Myupoad_page({this.pageController});
  @override
  _Myupoad_pageState createState() => _Myupoad_pageState();
}

File _image;

class _Myupoad_pageState extends State<Myupoad_page> {
  var captioncontroller = TextEditingController();

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        backgroundColor: Color.fromRGBO(245, 96, 64, 1).withOpacity(0.8),
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
          IconButton(
            onPressed: () {
              if (_image != null && captioncontroller != null) {
                widget.pageController.animateToPage(0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              } else {
                Utils.fireToast("rasm va izoh bo'sh bo'lmasligi kerak!");
              }
            },
            icon: const Icon(Icons.add_a_photo_outlined),
            color: const Color.fromRGBO(245, 96, 64, 1),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                // choose image
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(245, 96, 64, 1).withOpacity(0.3),
                  child: _image == null
                      ? GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.grey.shade900,
                              size: 60,
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            // Added photo
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: Image.file(
                                _image,
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
                                      icon: Icon(
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
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Caption",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 17),
                    ),
                    maxLines: null,
                    controller: captioncontroller,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
