import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReportReq {

  var _dio = Dio();
  // static const URL = 'http://10.0.2.2:3000/api/v1';
  static const URL = Urls.apiUrl;

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

      Fluttertoast.showToast(
        msg: 'your report has been submitted!',
        toastLength: Toast.LENGTH_LONG,
      );

      return userPosts.data['data']['report'];

    } on DioError catch (e) {

      if (e.response != null) {

        Fluttertoast.showToast(
          msg: e.response!.data['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        // throw Error();
        throw(e.response!.data['message']);

      } else {

        Fluttertoast.showToast(
          msg: 'Error reporting post!',
          toastLength: Toast.LENGTH_LONG,
        );

      }

      }

  }

  // -------------- End create post ----------------

}