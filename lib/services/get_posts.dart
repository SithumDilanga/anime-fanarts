
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetPosts {

  var _dio = Dio();
  static const URL = 'http://10.0.2.2:3000/api/v1';

// --------------- get all posts -----------------

  Future getAllPosts() async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      print('bearer $bearerToken');
      
      Response allPostsData = await _dio.get('$URL/posts?page=1&limit=20', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));
      print('All posts: ${allPostsData.data}');
      print(allPostsData.statusCode);
      print(allPostsData.statusMessage);
      print(allPostsData.headers);

      print('shit ${allPostsData.data['data']['posts']}');

      return allPostsData.data['data'];

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

  // --------------- End get all posts -----------------

}