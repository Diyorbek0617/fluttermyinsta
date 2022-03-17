// ignore_for_file: non_constant_identifier_names

class User {
  String uid = "";
  String password = "";
  String img_url = "";
  bool fallowed = false;
  int fallowers_count = 0;
  int fallowing_count = 0;
  String fullname = '';
  String email = '';

  String device_id = "";
  String device_type = "";
  String device_token = "";

  User({this.fullname, this.email, this.password});

  User.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        fullname = json["fullname"],
        email = json["email"],
        password = json["password"],
        img_url = json["img_url"],
        device_id = json["device_id"],
        device_type = json["device_type"],
        device_token = json["device_token"];

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullname": fullname,
        "email": email,
        "password": password,
        "img_url": img_url,
        "device_id": device_id,
        "device_type": device_type,
        "device_token": device_token,
      };

  @override
  bool operator ==(other) {
    return (other is User) && other.uid == uid;
  }
}
