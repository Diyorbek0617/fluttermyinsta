import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttermyinsta/model/post_model.dart';
import 'package:fluttermyinsta/model/user_model.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';
import 'package:fluttermyinsta/services/untills.dart';

class DataService {
  static Firestore firestore = Firestore.instance;
  static String folder_users = "users";
  static String folder_posts = "posts";
  static String folder_feeds = "feeds";
  static String folder_following = "following";
  static String folder_followers = "followers";

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

    var querySnapshot1 = await firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_followers)
        .getDocuments();
    user.fallowers_count = querySnapshot1.documents.length;

    var querySnapshot2 = await firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_following)
        .getDocuments();
    user.fallowing_count = querySnapshot2.documents.length;

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
        users.add(newUser);
      }
      // users.add(newUser);
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

    String postId = firestore
        .collection(folder_users)
        .document(me.uid)
        .collection(folder_posts)
        .document()
        .documentID;
    post.id = postId;

    await firestore
        .collection(folder_users)
        .document(me.uid)
        .collection(folder_posts)
        .document(postId)
        .setData(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = await Prefs.loadUserId();

    await firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_feeds)
        .document(post.id)
        .setData(post.toJson());
    return post;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = new List();
    String uid = await Prefs.loadUserId();
    var querySnapshot = await firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_feeds)
        .getDocuments();
    querySnapshot.documents.forEach((result) {
      Post post = Post.fromJson(result.data);
      if(post.uid==uid) post.mine=true;
      posts.add(post);
    });
    return posts;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = new List();
    String uid = await Prefs.loadUserId();
    var querySnapshot = await firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_posts)
        .getDocuments();
    querySnapshot.documents.forEach((result) {
      Post post = Post.fromJson(result.data);
      posts.add(post);
    });
    return posts;
  }

  static Future<Post> likePost(Post post, bool liked) async {
    String uid = await Prefs.loadUserId();
    post.liked = liked;

    await firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_feeds)
        .document(post.id)
        .setData(post.toJson());
    if (uid == post.uid) {
      await firestore
          .collection(folder_users)
          .document(uid)
          .collection(folder_posts)
          .document(post.id)
          .setData(post.toJson());
    }
  }

  static Future<List<Post>> loadLikes() async {
    String uid = await Prefs.loadUserId();
    List<Post> posts = new List();
    var querySnapshot = await firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_feeds)
        .where("liked", isEqualTo: true)
        .getDocuments();

    querySnapshot.documents.forEach((result) {
      Post post = Post.fromJson(result.data);
      // if(uid==post.uid)post.mine=true;
      posts.add(post);
    });
    return posts;
  }

  static Future<User> fallowUser(User someone) async {
    User me = await loadUser();

    await firestore
        .collection(folder_users)
        .document(me.uid)
        .collection(folder_following)
        .document(someone.uid)
        .setData(someone.toJson());
    await firestore
        .collection(folder_users)
        .document(someone.uid)
        .collection(folder_followers)
        .document(me.uid)
        .setData(me.toJson());

    return someone;
  }

  static Future<User> unfallowUser(User someone) async {
    User me = await loadUser();

    await firestore
        .collection(folder_users)
        .document(me.uid)
        .collection(folder_following)
        .document(someone.uid)
        .delete();
    await firestore
        .collection(folder_users)
        .document(someone.uid)
        .collection(folder_followers)
        .document(me.uid)
        .delete();

    return someone;
  }

  static Future storePostsToMyFeed(User someone) async {
    List<Post> posts = new List();
    var querySnapshot = await firestore
        .collection(folder_users)
        .document(someone.uid)
        .collection(folder_posts)
        .getDocuments();
    querySnapshot.documents.forEach((result) {
      var post = Post.fromJson(result.data);
      post.liked = false;
      posts.add(post);
    });
    for (Post post in posts) {
      storeFeed(post);
    }
  }

  static Future removePostsFromMyFeed(User someone) async {
    List<Post> posts = new List();
    var querySnapshot = await firestore
        .collection(folder_users)
        .document(someone.uid)
        .collection(folder_posts)
        .getDocuments();
    querySnapshot.documents.forEach((result) {
      var post = Post.fromJson(result.data);
      post.liked = false;
      posts.add(post);
    });
    for (Post post in posts) {
      removeFeed(post);
    }
  }

  static Future removeFeed(Post post) async {
    String uid = await Prefs.loadUserId();
    return await firestore
        .collection(folder_users)
        .document(uid)
        .collection(folder_feeds)
        .document(post.id)
        .delete();
  }
}
