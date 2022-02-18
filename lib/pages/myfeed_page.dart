import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttermyinsta/model/post_model.dart';

class Myfeed_page extends StatefulWidget {
 // const Myfeed_page({Key key}) : super(key: key);
  static final String id="myfeed_page";
  PageController pageController;
  Myfeed_page({this.pageController});
  @override
  _Myfeed_pageState createState() => _Myfeed_pageState();
}

class _Myfeed_pageState extends State<Myfeed_page> {
     List<Post> items= new List();
  bool isloading=false;
  String img1="https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost.png?alt=media&token=f0b1ba56-4bf4-4df2-9f43-6b8665cdc964";
  String img2="https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost2.png?alt=media&token=ac0c131a-4e9e-40c0-a75a-88e586b28b72";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    items.add(Post(postImage: img1,caption: "Discover more geat images"));
    items.add(Post(postImage: img2,caption: "Discover more geat images"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Instagram",style: TextStyle(fontFamily: "Billabong",fontSize: 25,color: Colors.black,),),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){
              widget.pageController.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
            icon: Icon(Icons.camera_alt),
            color: Colors.grey,
          ),
        ],
      ),
      body:ListView.builder(

        itemCount: items.length,
        itemBuilder: ( context, index){
          return _itemsofPost(items[index]);
        },
      ),
    );
  }
  Widget _itemsofPost(Post post){
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
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Username",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                          Text("February 16, 2022",style: TextStyle(fontWeight: FontWeight.normal),)
                        ],
                      )
                    ],
                  ),
                  IconButton(
                    icon: const Icon(SimpleLineIcons.options),
                    onPressed: (){},
                  ),
                ],
              )),
         // Image.network(post.postImage,fit: BoxFit.cover,),
          Center(
            child: CachedNetworkImage(
              imageUrl: post.postImage,
              placeholder: (context,url)=>CircularProgressIndicator(),
              errorWidget: (context, url,error)=>Icon(Icons.error),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (){},
                    icon: Icon(FontAwesome.heart_o),
                  ),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(FontAwesome.send),
                  ),
                ],
              ),
            ],
          ),
          Text(post.caption,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),

        ],
      ),

    );
  }
}
