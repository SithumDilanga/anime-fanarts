import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:anime_fanarts/models/quote.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseCloudMessaging {      
  
  static const URL = Urls.apiUrl;

  var _dio = Dio();

  final FirebaseMessaging _fc = FirebaseMessaging.instance;

  void configureCallbacks() {

    // FirebaseMessaging.onBackgroundMessage((message) async => message.data);
    FirebaseMessaging.onMessage.listen((event) {
      print('message received');
      print(event.notification!.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

  }

  void subscribeToEvent() {

    _fc.subscribeToTopic('Quote');

  }

  // ------------ send daily quote ---------------

  Future sendDailyQuote({required Quote dailyQuote}) async {

    Quote? retrievedDailyQuote;
    Response? response;
    var _dio = Dio();

    try {

      response = await _dio.post('$URL/daily/createQuote', data: dailyQuote.toJson());

      print(response.statusCode);
      print('User created: ${response.data}');

      Fluttertoast.showToast(
        msg: 'Quote Sent Successfully!',
        toastLength: Toast.LENGTH_LONG,
      );

      retrievedDailyQuote = Quote.fromJson(response.data);

    } on DioError catch (e) {

      if(e.type == DioErrorType.response) {
        print('bitch catched!');
      }

      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');

        Fluttertoast.showToast(
          msg: e.response!.data['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        // returning error status code
        return e.response!.statusCode;

      } else {

        Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_LONG,
        );

        print('Error sending request!');
        print(e.message);
        return e.message;
      }

    }

    return retrievedDailyQuote;

  }

  // ------------ End send daily quote ---------------

  // -------------- send device token ----------------

  Future sendDevToken({String? devToken}) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';    
      
      
      Response userPosts = await _dio.post('$URL/daily/saveDeviceToken', data: {
        'deviceToken': devToken,
      }, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      print('response ${userPosts.data}');

      Fluttertoast.showToast(
        msg: 'dev token has been sent!',
        toastLength: Toast.LENGTH_LONG,
      );

    } on DioError catch (e) {

      if (e.response != null) {

        Fluttertoast.showToast(
          msg: 'Error sending token!',
          toastLength: Toast.LENGTH_LONG,
        );

        // throw Error();
        throw(e.response!.data['message']);

      } else {

        Fluttertoast.showToast(
          msg: 'Error sending token!',
          toastLength: Toast.LENGTH_LONG,
        );

      }

      }

  }

  // -------------- End send device token ----------------

  // -------------- send commented push notification -------------

  Future sendCommentPushNotification({String? userId, String? postId, String? currentUserName, String? commentType}) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';    
      
      
      Response userNotification = await _dio.post('$URL/daily/sendMsgToDevice/$userId', data: {
        'userId': userId,
        'postId': postId,
        'currentUserName': currentUserName,
        'commentType': commentType
      }, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      // Fluttertoast.showToast(
      //   msg: 'comment notification has been sent!',
      //   toastLength: Toast.LENGTH_LONG,
      // );


    } on DioError catch (e) {

      if (e.response != null) {

        // Fluttertoast.showToast(
        //   msg: 'Error sending notification!',
        //   toastLength: Toast.LENGTH_LONG,
        // );

        // throw Error();
        throw(e.response!.data['message']);

      } else {

        // Fluttertoast.showToast(
        //   msg: 'Error sending notification!',
        //   toastLength: Toast.LENGTH_LONG,
        // );

      }

    }
  }

  // -------------- End send commented push notification -------------

}