import 'dart:io';

import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReportReq {

  var _dio = Dio();
  // static const URL = 'http://10.0.2.2:3000/api/v1';
  static const URL = 'https://vast-cliffs-19346.herokuapp.com/api/v1';

  // -------------- create post ----------------

  Future reportPost({String? reason, String? description, String? postId}) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';    
      
      
      Response userPosts = await _dio.post('$URL/reports', data: {
        'reason': reason,
        'description': description,
        'post': postId
      }, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      print('create post: ${userPosts.data}');
      print(userPosts.statusCode);
      print(userPosts.statusMessage);
      print(userPosts.headers);

      Fluttertoast.showToast(
        msg: 'your report has been submitted!',
        toastLength: Toast.LENGTH_LONG,
      );

      return userPosts.data['data']['report'];

    } on DioError catch (e) {

      print('Error creating post : $e');

      if (e.response != null) {

        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');

        // return e.response!.statusCode;

        Fluttertoast.showToast(
          msg: e.response!.data['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        // throw Error();
        throw(e.response!.data['message']);

      } else {

        Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_LONG,
        );

        print('Error sending request!');
        print(e.message);
      }

      }

  }

  // -------------- End create post ----------------

}