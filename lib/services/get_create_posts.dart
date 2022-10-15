import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';

class GetCreatePosts extends ChangeNotifier {

  var _dio = Dio();
  // static const URL = 'http://10.0.2.2:3000/api/v1';
  static const URL = Urls.apiUrl;

// --------------- get all posts -----------------

  Future getAllPosts(int pageKey, int pageSize) async {

    Response allPostsData;

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      final blockedUsersList = SharedPref.getBlockedUserIdsList() ?? [];

      String blockedList = blockedUsersList.toString()
      .replaceAll('[', '')
      .replaceAll(']','')
      .replaceAll(' ', '');

      print('stringedList ' + blockedList);

      if(blockedList.isEmpty) {

        // print('no blocked users');

        allPostsData = await _dio.get(
          '$URL/posts?page=$pageKey&limit=$pageSize',
          options: Options(
            headers: {'Authorization': 'Bearer $bearerToken'},
        ));

      } else {

        // print('have blocked users');

        allPostsData = await _dio.get(
          '$URL/posts?page=$pageKey&limit=${pageSize + 8}&blockedList=$blockedList',
        options: Options(
          headers: {'Authorization': 'Bearer $bearerToken'},
        ));

      }
      
      return allPostsData.data;

    } on DioError catch (e) {

      if (e.response != null) {

        // return e.response!.statusCode;

        Fluttertoast.showToast(
          msg: e.response!.data['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        // throw Error();
        throw(e.response!.data['message']);

      } else {

        Fluttertoast.showToast(
          msg: 'Error loading data check your netwrok connection!',
          toastLength: Toast.LENGTH_LONG,
        );
      }

    }

  }

  // --------------- End get all posts -----------------

  // -------------- create post ----------------

  Future createPost({List? postImageFile, String? desc, List<String>? tags,}) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      FormData data;
      var formData = FormData();

      if(postImageFile![0].path == null) {

        data = FormData.fromMap({
          'description': desc
        });

      } else {

        String imageSize = '';

        // String fileName = postImageFile!.path.split('/').last;

        // List<String> postImageFiles = ['sdsd', 'sdsd'];

        
        // for (var file in postImageFile) {
        //   formData.files.addAll([
        //   MapEntry("postimg", await MultipartFile.fromFile(file.path)),
        //   ]);
        // }
        List? imageList = [];

        for (int i = 0; i < postImageFile.length; i++) {

          print('yoyo' + imageList.toString());

          if(i == 0) {

            var decodedImage = await decodeImageFromList(postImageFile[i].readAsBytesSync());
          
            print('image width ${decodedImage.width}');
            print('image heigh ${decodedImage.height}');

            imageSize = 'size' + '${decodedImage.height}' + '-' + '${decodedImage.width}';

            print('imageSize $imageSize');

          }

          imageList.add(
            MultipartFile.fromFileSync(postImageFile[i].path, filename: 'img$i.jpg', contentType: MediaType('image', 'jpeg'))
          );

        }

        formData = FormData.fromMap({
          // 'postimg': [
          //   MultipartFile.fromFileSync(postImageFile[0].path, filename: 'img1.jpg', contentType: MediaType('image', 'jpeg')),
          //   MultipartFile.fromFileSync(postImageFile[1].path, filename: 'img2.jpg', contentType: MediaType('image', 'jpeg')),
          // ],
          'heightWidth': imageSize,
          'postimg': imageList,
          'description': desc,
          'tags': tags,
        });

      }
      
      
      Response userPosts = await _dio.post('$URL/posts', data: formData, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      Fluttertoast.showToast(
        msg: 'Post added!',
        toastLength: Toast.LENGTH_LONG,
      );

      return userPosts.data['data']['posts'];

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
          msg: 'Error loading data check your netwrok connection!',
          toastLength: Toast.LENGTH_LONG,
        );

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

      Fluttertoast.showToast(
        msg: 'Post successfully deleted!',
        toastLength: Toast.LENGTH_LONG,
      );

      return userPosts.statusCode;

    } on DioError catch (e) {

      if (e.response != null) {

        // return e.response!.statusCode;

        Fluttertoast.showToast(
          msg: e.response!.data['message'],
          toastLength: Toast.LENGTH_LONG,
        );

        // throw Error();
        throw(e.response!.data['message']);

      } else {

        Fluttertoast.showToast(
          msg: 'Error sending request check your netwrok connection!',
          toastLength: Toast.LENGTH_LONG,
        );

      }

      }

  }

  // -------------- End delete post ----------------












  // NEW REACTION SHIT

  // --------------- get all posts -----------------

  // Future getAllPostsNew() async {

  //   // int page = pageNum;

  //   try {

  //     final bearerToken = await SecureStorage.getToken() ?? '';

      
  //     Response allPostsData = await _dio.get('$URL/posts', options: Options(
  //       headers: {'Authorization': 'Bearer $bearerToken'},
  //     ));


  //     print('shit ${allPostsData.data['data']['reacted']}');

  //     return allPostsData.data;

  //   } on DioError catch (e) {

  //     print('Error creating post : $e');

  //     if (e.response != null) {

  //       print('Dio error!');
  //       print('STATUS: ${e.response?.statusCode}');
  //       print('DATA: ${e.response?.data}');
  //       print('HEADERS: ${e.response?.headers}');

  //       // return e.response!.statusCode;

  //       Fluttertoast.showToast(
  //         msg: e.response!.data['message'],
  //         toastLength: Toast.LENGTH_LONG,
  //       );

  //       // throw Error();
  //       throw(e.response!.data['message']);

  //     } else {

  //       Fluttertoast.showToast(
  //         msg: e.message,
  //         toastLength: Toast.LENGTH_LONG,
  //       );

  //       print('Error sending request!');
  //       print(e.message);
  //     }

  //   }

  // }

  // --------------- End get all posts -----------------

}