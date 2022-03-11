class Post {
  String uid = '';
  String fullname = '';
  String img_user = '';
  String id = '';
  String img_post = '';
  String caption = '';
  String date;

  Post({
    this.img_post,
    this.caption,
  });

  Post.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullname = json['fullname'],
        img_user = json['img_user'],
        img_post = json['img_post'],
        id = json['id'],
        date = json['date'],
        caption = json['caption'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'fullname': fullname,
        'img_user': img_user,
        'id': id,
        'img_post': img_post,
        'date': date,
        'caption': caption,
      };
}
