import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/model/user_model.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';
import 'package:fluttermyinsta/services/untills.dart';

class DataService {
  static Firestore firestore = Firestore.instance;
  static String folder_users = "users";
  static String folder_posts = "posts";
  static String folder_feeds = "feeds";

  // User Related
  static Future storeUser(User user) async {
    user.uid = await Prefs.loadUserId();
    return firestore
        .collection(folder_users)
        .document(user.uid)
        .setData(user.toJson());
  }

  static Future<User> loadUser({String id}) async {
    String uid = await Prefs.loadUserId();
    var value = await firestore.collection(folder_users).document(uid).get();
    User user = User.fromJson(value.data);
    return user;
  }

  static Future updateUser(User user) async {
    String uid = await Prefs.loadUserId();
    return firestore
        .collection(folder_users)
        .document(uid)
        .updateData(user.toJson());
  }

  static Future<List<User>> searchUsers(String keyword) async {
    List<User> users = new List();
    String uid = await Prefs.loadUserId();
    final Firestore firestore = Firestore.instance;

    var querySnapshot = await firestore
        .collection(folder_users)
        .orderBy("email")
        .startAt([keyword]).getDocuments();
    print(querySnapshot.documents.length);

    querySnapshot.documents.forEach((user) {
      User newUser = User.fromJson(user.data);
       if (newUser.uid != uid) {
       //  users.add(newUser);
       }
      users.add(newUser);
    });
    return users;
  }
  // Post Related

  static Future<Post> storePost(Post post) async {
    User me = await loadUser();
    post.uid = me.uid;
    post.fullname = me.fullname;
    post.img_user = me.img_url;
    post.date = Utils.currentDate();

    String postId = firestore.collection(folder_users).document(me.uid).collection(folder_posts).document().documentID;
    post.id = postId;

    await firestore.collection(folder_users).document(me.uid).collection(folder_posts).document(postId).setData(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = await Prefs.loadUserId();

    await firestore.collection(folder_users).document(uid).collection(folder_feeds).document(post.id).setData(post.toJson());
    return post;
  }

  static Future <List<Post>>loadFeeds()async{
    List<Post> posts =new List();
    String uid= await Prefs.loadUserId();
    var querySnapshot = await firestore.collection(folder_users).document(uid).collection(folder_feeds).getDocuments();
    querySnapshot.documents.forEach((result){
      Post post =Post.fromJson(result.data);
      posts.add(post);
    });
    return posts;
  }

  static Future <List<Post>>loadPosts()async{
    List<Post> posts =new List();
    String uid= await Prefs.loadUserId();
    var querySnapshot = await firestore.collection(folder_users).document(uid).collection(folder_posts).getDocuments();
    querySnapshot.documents.forEach((result){
      Post post =Post.fromJson(result.data);
      posts.add(post);
    });
    return posts;
  }

}
