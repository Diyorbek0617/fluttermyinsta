import 'package:flutter/material.dart';
import 'package:fluttermyinsta/model/user_model.dart';
import 'package:fluttermyinsta/services/data_service.dart';

class Mysearch_page extends StatefulWidget {
  const Mysearch_page({Key key}) : super(key: key);
  static final String id = "mysearch_page";

  @override
  _Mysearch_pageState createState() => _Mysearch_pageState();
}

class _Mysearch_pageState extends State<Mysearch_page> {
  var searchcontroller = TextEditingController();
  bool isLoading=false;
  List<User> items = List();
void _apisearchuser(String keyword){
  setState(() {
    isLoading=true;
  });
  DataService.searchUsers(keyword).then((users) => {
    _ressearchusers(users),
  });
}
void _ressearchusers(List<User>users){
  setState(() {
    items=users;
    isLoading=false;
  });
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
        title:Text(
          "Search",
          style: TextStyle(
              color: Colors.black, fontFamily: "Billabong", fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                // search
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  height: 45,
                  child: TextField(
                    controller: searchcontroller,
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (input){
                      _apisearchuser(input);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, index) {
                      return _itemofuser(items[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          isLoading? Center(child: CircularProgressIndicator(),):SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemofuser(User user) {
    return Container(
      height: 90,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                border: Border.all(
                  width: 1.5,
                  color: Color.fromRGBO(192, 53, 132, 1),
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child:user.img_url.isEmpty? Image(
                image: AssetImage("assets/images/ic_person.png"),
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ):Image.network(
                user.img_url,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullname,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                user.email,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
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
                      "Fallow",
                      style: TextStyle(color: Colors.white, fontSize: 13),
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
