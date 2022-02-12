import 'dart:io';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';

class GetCreatePosts extends ChangeNotifier {

  var _dio = Dio();
  // static const URL = 'http://10.0.2.2:3000/api/v1';
  static const URL = 'https://vast-cliffs-19346.herokuapp.com/api/v1';

// --------------- get all posts -----------------

  Future getAllPosts(int pageKey, int pageSize) async {

    // int page = pageNum;

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      print('bearer $bearerToken');
      
      Response allPostsData = await _dio.get('$URL/posts?page=$pageKey&limit=$pageSize', options: Options(
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

  Future createPost({List? postImageFile, String? desc, List<String>? tags}) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      FormData data;
      var formData = FormData();


      if(postImageFile![0].path == null) {

        data = FormData.fromMap({
          'description': desc
        });

      } else {

        // String fileName = postImageFile!.path.split('/').last;
        // print('file $postImageFile');
        // print('fileName $fileName');

        // List<String> postImageFiles = ['sdsd', 'sdsd'];

        
        // for (var file in postImageFile) {
        //   formData.files.addAll([
        //   MapEntry("postimg", await MultipartFile.fromFile(file.path)),
        //   ]);
        // }
        List? imageList = [];

        for (int i = 0; i < postImageFile.length; i++) {

          print('yoyo' + imageList.toString());

          imageList.add(
            MultipartFile.fromFileSync(postImageFile[i].path, filename: 'img$i.jpg', contentType: MediaType('image', 'jpeg'))
          );

        }

        formData = FormData.fromMap({
          // 'postimg': [
          //   MultipartFile.fromFileSync(postImageFile[0].path, filename: 'img1.jpg', contentType: MediaType('image', 'jpeg')),
          //   MultipartFile.fromFileSync(postImageFile[1].path, filename: 'img2.jpg', contentType: MediaType('image', 'jpeg')),
          // ],
          'postimg': imageList,
          'description': desc,
          'tags': tags
        });

        // data = FormData.fromMap({
        //   'postimg': await MultipartFile.fromFile(
        //     postImageFile.path,
        //     filename: fileName,
        //     contentType: MediaType('image', 'jpg'),
        //   ),
        //   'description': desc,
        //   'tags': tags
        // });

        // data = FormData.fromMap({
        //   "files": [  
        //     MultipartFile.fromFileSync(postImageFile[0].path,
        //         filename: "upload.txt"),
        //     MultipartFile.fromFileSync(postImageFile[1].path,
        //         filename: "upload2.txt"),
        //   ]
        // });

      }
      
      
      Response userPosts = await _dio.post('$URL/posts', data: formData, options: Options(
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

  Future deletePost(String? postId) async {

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
        msg: 'post successfully deleted!',
        toastLength: Toast.LENGTH_LONG,
      );

      return userPosts.statusCode;

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