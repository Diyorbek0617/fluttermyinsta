import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';

class FileService {
  static final _storage = FirebaseStorage.instance.ref();
  static const folder_post = "post_images";
  static const folder_user = "user_images";
// upload user image
  static Future<String> uploadUserImage(File _image) async {
    String uid = await Prefs.loadUserId();
    String img_name = uid;
    StorageReference firebaseStorageRef =
        _storage.child(folder_user).child(img_name);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    if (taskSnapshot != null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    }
    return null!;
  }

// upload post image
  static Future<String> uploadPostImage(File _image) async {
    String uid = await Prefs.loadUserId();
    String img_name = uid + "_" + DateTime.now().toString();
    StorageReference firebaseStorageRef =
        _storage.child(folder_post).child(img_name);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    if (taskSnapshot != null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    }
    return null!;
  }
}
