import 'dart:io';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';

class GetCreatePosts {

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

      print('shit ${allPostsData.data['data']['reacted']}');

      return allPostsData.data;

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

  // -------------- create post ----------------

  Future createPost({File? postImageFile, String? desc, List<String>? tags}) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      FormData data;
      


      if(postImageFile?.path == null) {

        data = FormData.fromMap({
          'description': desc
        });

      } else {

        String fileName = postImageFile!.path.split('/').last;
        print('file $postImageFile');
        print('fileName $fileName');

        data = FormData.fromMap({
          'postimg': await MultipartFile.fromFile(
            postImageFile.path,
            filename: fileName,
            contentType: MediaType('image', 'jpg'),
          ),
          'description': desc,
          'tags': tags
        });

        // data = FormData.fromMap({
        //   "files": [  
        //     MultipartFile.fromFileSync(postImageFile[0].path,
        //         filename: "upload.txt"),
        //     MultipartFile.fromFileSync(postImageFile[1].path,
        //         filename: "upload2.txt"),
        //   ]
        // });

      }
      
      
      Response userPosts = await _dio.post('$URL/posts', data: data, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      print('create post: ${userPosts.data}');
      print(userPosts.statusCode);
      print(userPosts.statusMessage);
      print(userPosts.headers);

      Fluttertoast.showToast(
        msg: 'post added!',
        toastLength: Toast.LENGTH_LONG,
      );

      return userPosts.data['data']['posts'];

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


  // -------------- delete post ----------------

  Future deletePost(String postId) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';      
      
      
      Response userPosts = await _dio.delete('$URL/posts/$postId', data: {

      }, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      print('create post: ${userPosts.data}');
      print(userPosts.statusCode);
      print(userPosts.statusMessage);
      print(userPosts.headers);

      Fluttertoast.showToast(
        msg: 'post added!',
        toastLength: Toast.LENGTH_LONG,
      );

      return userPosts.data['data']['posts'];

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

  // -------------- End delete post ----------------

}