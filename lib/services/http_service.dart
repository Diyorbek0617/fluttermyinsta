import 'dart:convert';
import 'package:http/http.dart';
//  network service for someone user
class HttpService {
  static String BASE = 'fcm.googleapis.com';
  static String API_SEND = '/fcm/send';
  // for notification
  static Map<String, String> headers = {
    'Authorization':
        'key=eeWtT6tFL8I:APA91bGdfm3G91WJAxNIT4BKdnnIgswFJC8Q6cFIinO2j8R4URhg4-EIJWRSKhxa-HlnUJI7aAru082XIpnxLP2_74F8r7SMvpRri0LqhF7auFtjkrN0h_pp10Xc1cO9dFJpxWvSIw11',
    'Content-Type': 'application/json'
  };

  static Future<String> POST(Map<String, dynamic> params) async {
    var uri = Uri.https(BASE, API_SEND);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null!;
  }

  static Map<String, dynamic> paramCreate(String username, String fcmToken) {
    Map<String, dynamic> params = {};
    params.addAll({
      'notification': {
        'title': 'My Instagram',
        'body': '$username followed you!'
      },
      'registration_ids': [fcmToken],
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    });
    return params;
  }
}
