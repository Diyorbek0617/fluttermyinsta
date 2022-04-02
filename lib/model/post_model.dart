import 'package:fluttermyinsta/model/user_model.dart';

class Post {
  String? uid = '';
  String fullname = '';
  String img_user = '';
  String id = '';
  String img_post = '';
  String caption = '';
  bool liked = false;
  String? date;
  bool mine = false;

  Post({
    required this.img_post,
    required this.caption,
  });

  Post.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullname = json['fullname'],
        img_user = json['img_user'],
        img_post = json['img_post'],
        id = json['id'],
        date = json['date'],
        caption = json['caption'],
        liked = json['liked'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullname': fullname,
        'img_user': img_user,
        'id': id,
        'img_post': img_post,
        'date': date,
        'caption': caption,
        'liked': liked,
      };
  @override
  bool operator ==(Object other) {
    return (other is User) && other.uid == uid;
  }
  @override
  int get hashCode => uid.hashCode;
}
