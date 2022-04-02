import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttermyinsta/services/prefs_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  // for dialog page
  static void fireToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade700,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  //for date
  static String currentDate() {
    DateTime now = DateTime.now();

    String convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}:${now.minute.toString()}";
    return convertedDateTime;
  }

  // dialog
  static Future<bool> dialogCommon(
      BuildContext context, String title, String message, bool isSingle) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              !isSingle
                  ? TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    )
                  : const SizedBox.shrink(),
              TextButton(
                child: const Text("Confirm"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

//device
  static Future<Map<String, String>> deviceParams() async {
    Map<String, String> params = {};
    var deviceInfo = DeviceInfoPlugin();
    String fcmToken = await Prefs.loadFCM();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      params.addAll({
        'device_id': iosDeviceInfo.identifierForVendor,
        'device_type': "I",
        'device_token': fcmToken,
      });
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      params.addAll({
        'device_id': androidDeviceInfo.androidId,
        'device_type': "A",
        'device_token': fcmToken,
      });
    }
    return params;
  }

// for notification
  static Future<void> showLocalNotification(
      Map<String, dynamic> message) async {
    String title = message['title'];
    String body = message['body'];

    if (Platform.isAndroid) {
      title = message['notification']['title'];
      body = message['notification']['body'];
    }

    var android = const AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription');
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);

    int id = Random().nextInt((pow(2, 31)-1).toInt());
    await FlutterLocalNotificationsPlugin().show(id, title, body, platform);
  }
}
