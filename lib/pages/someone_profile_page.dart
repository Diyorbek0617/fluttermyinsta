import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/model/user_model.dart';
import 'package:fluttermyinsta/services/data_service.dart';
import 'package:fluttermyinsta/services/http_service.dart';

class SomeoneProfilePage extends StatefulWidget {
  static const String id = 'someone_Profile_Page';

   Post? post;
   SomeoneProfilePage({Key? key, this.post}) : super(key: key);

  @override
  _SomeoneProfilePageState createState() => _SomeoneProfilePageState();
}

class _SomeoneProfilePageState extends State<SomeoneProfilePage> {
  // values
  List<Post> items = [];
  bool iscorrect = false;
  bool isLoading = false;
  int count_posts = 0, countFollowers = 0, countFollowing = 0;

  String? fullName = '', email = '', imgUrl='';
   User? someoneUser;

  @override
  void initState() {
    super.initState();

    _apiLoadUser();
    _apiLoadPosts();
  }

  _apiLoadUser() async {
    setState(() {
      isLoading = true;
    });

    await DataService.someOneLoadUser(id: widget.post!.uid).then((value) => {
          _showUserInfo(value),
        });
  }

  _showUserInfo(User? user) {
    setState(() {
      someoneUser = user;
      this.fullName = user!.fullname;
      this.email = user.email;
      this.imgUrl = user.img_url;
      this.countFollowers = user.fallowers_count;
      this.countFollowing = user.fallowing_count;
      isLoading = false;
    });
  }

  _apiLoadPosts() {
    DataService.loadPosts(id: widget.post!.uid)
        .then((value) => {_resLoadPosts(value)});
  }

  _resLoadPosts(List<Post> posts) {
    setState(() {
      items = posts;
      count_posts = items.length;
    });
  }

  // Follow action
  _apiFollowUser(User someone) async {
    setState(() {
      isLoading = true;
    });

    await DataService.fallowUser(someone);

    setState(() {
      someone.fallowed = true;
      isLoading = false;
    });

    DataService.storePostsToMyFeed(someone);

    // Notification
    String username = '';
    DataService.loadUser().then((userMe) {
      username = userMe.fullname;
    });

    Map<String, dynamic> params =
        HttpService.paramCreate(username, someone.device_token);
    HttpService.POST(params);

    _apiLoadUser();
  }

  _apiUnfollowUser(User someone) async {
    setState(() {
      isLoading = true;
    });

    await DataService.unfallowUser(someone);

    setState(() {
      someone.fallowed = false;
      isLoading = false;
    });

    DataService.removePostsFromMyFeed(someone);

    _apiLoadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontFamily: 'Billabong'),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Profile image
                Stack(
                  children: [
                    // Profile Image
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(
                              color: const Color(0xffFCAF45), width: 1.5)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: imgUrl == null || imgUrl!.isEmpty
                            ? const Image(
                                image:
                                    AssetImage("assets/images/ic_person.png"),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                imgUrl!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                ),

                // FullName
                Text(
                  fullName!.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(
                  height: 5,
                ),

                // FullName
                Text(
                  email!,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),

                const SizedBox(
                  height: 10,
                ),

                // Button : Follow
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (someoneUser!.fallowed) {
                          _apiUnfollowUser(someoneUser!);
                        } else {
                          _apiFollowUser(someoneUser!);
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: Colors.blueGrey,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            someoneUser != null ? (someoneUser!.fallowed ? "Fallowing" : "Fallow"): "Follow",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // POSTS || FOLLOWERS || FOLLOWING
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Row(
                    children: [
                      // POSTS
                      Expanded(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              count_posts.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
                              'Post',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),

                      Container(
                        height: 20,
                        width: 1,
                        color: Colors.grey.withOpacity(0.6),
                      ),

                      // FOLLOWERS
                      Expanded(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              countFollowers.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
                              'Followers',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),

                      Container(
                        height: 20,
                        width: 1,
                        color: Colors.grey.withOpacity(0.6),
                      ),

                      // FOLLOWING
                      Expanded(
                          child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              countFollowing.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
                              'Following',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            iscorrect = false;
                          });
                        },
                        icon: const Icon(Icons.list_alt_outlined),
                      ),
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
                const SizedBox(
                  height: 1,
                ),
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            "No Post",
                            style: TextStyle(color: Colors.black26),
                          ),
                        )
                      : iscorrect == false
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

  Widget _itemsofpost(Post post) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              imageUrl: post.img_post,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          iscorrect == false
              ? Text(
                  post.caption,
                  style: const TextStyle(color: Colors.black87, fontSize: 9),
                  softWrap: true,
                )
              : const SizedBox.shrink(),
          const Divider(),
        ],
      ),
    );
  }
}
