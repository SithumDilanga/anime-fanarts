import 'dart:io';

import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';

class ProfileReq {

  var _dio = Dio();
  // static const URL = 'http://10.0.2.2:3000/api/v1';
  static const URL = Urls.apiUrl;

  // ----------- getting user details(/me route) --------------

  // TODO: get data through a model class
  Future getUser() async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      
      Response userData = await _dio.get('$URL/users/me', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      return userData.data['data']['users'];

    } on DioError catch (e) {

      if(e.type == DioErrorType.response) {
      }

      if (e.response != null) {

        // returning error status code
        return e.response!.statusCode;

      } else {

        Fluttertoast.showToast(
          msg: 'Error getting user data!',
          toastLength: Toast.LENGTH_LONG,
        );

        return e.message;
      }

    }
  }

  // ----------- End getting user details(/me route) --------------

  // ----------- get user posts --------------------

  Future getUserPosts(int pageKey, int pageSize) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      
      Response userPosts = await _dio.get('$URL/posts/myPosts?page=$pageKey&limit=$pageSize', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      return userPosts.data;

    } on DioError catch (e) {

      if (e.response != null) {
        // returning error status code
        return e.response!.statusCode;

      } else {

        Fluttertoast.showToast(
          msg: 'Error getting user posts data!',
          toastLength: Toast.LENGTH_LONG,
        );

        return e.message;
      }

    }

  }

  // ----------- End get user posts --------------------

  // ----------- get user profile details -------------

  Future getUserProfile({required String id}) async {

    try {


      final bearerToken = await SecureStorage.getToken() ?? '';
      
      Response userData = await _dio.get('$URL/users/$id', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      return userData.data['data']['users'];

    } on DioError catch (e) {

      if (e.response != null) {

        // returning error status code
        return e.response!.statusCode;

      } else {

        Fluttertoast.showToast(
          msg: 'Error getting user data!',
          toastLength: Toast.LENGTH_LONG,
        );

        return e.message;
      }

    }
  }

  // ----------- End get user profile details -------------

  // ------------ upload profile picture -------------

  Future uploadProfilePic(File file) async {

    String fileName = file.path.split('/').last;

    
    FormData data = FormData.fromMap({
      'profilePic': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType('image', 'jpg'),
      ),
      // 'type': 'image/jpg'
      // 'name': 'sdlive'
    });

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      Response response = await _dio.patch('$URL/users/updateMe', data: data, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
        contentType: 'multipart/form-data'
      ));


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
        msg: 'Error uploading profile picture!',
        toastLength: Toast.LENGTH_LONG,
      );

    }

    }

  }

  // ------------ End upload profile picture -------------

  // ------------ upload cover picture -------------

  Future uploadCoverPic(File file) async {

    String fileName = file.path.split('/').last;
    
    FormData data = FormData.fromMap({
      'coverPic': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType('image', 'jpg'),
      ),
      // 'type': 'image/jpg'
      // 'name': 'sdlive'
    });

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      Response response = await _dio.patch('$URL/users/updateMe', data: data, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
        contentType: 'multipart/form-data'
      ));


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
        msg: 'Error uploading cover picture!',
        toastLength: Toast.LENGTH_LONG,
      );

    }

    }

  }

  // ------------ End upload cover picture -------------

  // ------------ update bio -------------

  Future updateBio(String bio) async {

    // String fileName = file.path.split('/').last;
    
    FormData data = FormData.fromMap({
      'bio': bio,
      // 'type': 'image/jpg'
      // 'name': 'sdlive'
    });

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      Response response = await _dio.patch('$URL/users/updateMe', data: data, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
        contentType: 'multipart/form-data'
      ));

      Fluttertoast.showToast(
        msg: 'Bio Updated!',
        toastLength: Toast.LENGTH_LONG,
      );


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
        msg: 'Error updating bio!',
        toastLength: Toast.LENGTH_LONG,
      );

    }

    }

  }

  // ------------ End update bio -------------

  // ------------ update username -------------

  Future updateUsername(String username) async {

    // String fileName = file.path.split('/').last;
    
    FormData data = FormData.fromMap({
      'name': username,
      // 'type': 'image/jpg'
      // 'name': 'sdlive'
    });

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      Response response = await _dio.patch('$URL/users/updateMe', data: data, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
        contentType: 'multipart/form-data'
      ));

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
        msg: 'Error updating username',
        toastLength: Toast.LENGTH_LONG,
      );

    }

    }

  }

  // ------------ End update username -------------

  // ------------ get user by id -------------

  Future getUserById({required String id, required int pageKey, required int pageSize}) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      
      Response userData = await _dio.get('$URL/users/$id?page=$pageKey&limit=$pageSize', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      return userData.data;

    } on DioError catch (e) {

      if (e.response != null) {
    
        return e.response!.statusCode;

      } else {
        
        Fluttertoast.showToast(
          msg: 'Error getting user data!',
          toastLength: Toast.LENGTH_LONG,
        );


        return e.message;
      }

    }
  }

  // ------------ End get user by id -------------

  // ------------ update social platforms -------------

  Future updateSocialPlatforms({String? twitter, String? insta, String? tiktok, String? deviatArt, String? website, String? pinterest, String? artstation}) async {

    // String fileName = file.path.split('/').last;
    
    FormData data = FormData.fromMap({
      'socialPlatforms': [
        {
          'socialPlatform': 'twitter',
          'link': twitter
        },
        {
          'socialPlatform': 'insta',
          'link': insta
        },
        {
          'socialPlatform': 'pinterest',
          'link': pinterest
        },
        {
          'socialPlatform': 'deviantArt',
          'link': deviatArt
        },
        {
          'socialPlatform': 'artstation',
          'link': artstation
        },
        {
          'socialPlatform': 'tiktok',
          'link': tiktok
        },
        {
          'socialPlatform': 'website',
          'link': website
        }
      ]
    });

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      Response response = await _dio.patch('$URL/users/updateSocialPlatforms', data: data, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
        contentType: 'multipart/form-data'
      ));

      Fluttertoast.showToast(
        msg: 'succesfully updated!',
        toastLength: Toast.LENGTH_LONG,
      );

    } on DioError catch (e) {

    if (e.response != null) {

      Fluttertoast.showToast(
        msg: 'Error updating social media platforms',
        toastLength: Toast.LENGTH_LONG,
      );

      // throw Error();
      throw(e.response!.data['message']);

    } else {

      Fluttertoast.showToast(
        msg: 'Error updating username',
        toastLength: Toast.LENGTH_LONG,
      );

    }

    }

  }

  // ------------ End update social platforms -------------

  // ------------ update social platforms -------------

  Future addNewfollowUpUser({String? userId}) async {

    // String fileName = file.path.split('/').last;
    
    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      final followedUserId = await SecureStorage.getUserId() ?? '';
      final deviceId = await SecureStorage.getDeviceId() ?? '';

      print('userId $userId');
      print('followedUserId $followedUserId');
      print('deviceId $deviceId');

      print('data $userId');

      Response response = await _dio.post('$URL/follow', data: {
        'followedUser': userId,
        'follow': 1,
        'deviceID': deviceId
      }, options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      print('response $response');

      Fluttertoast.showToast(
        msg: 'succesfully followed!',
        toastLength: Toast.LENGTH_LONG,
      );

    } on DioError catch (e) {

    if (e.response != null) {

      Fluttertoast.showToast(
        msg: 'Error following!',
        toastLength: Toast.LENGTH_LONG,
      );

      // throw Error();
      throw(e.response!.data['message']);

    } else {

      Fluttertoast.showToast(
        msg: 'Error updating username',
        toastLength: Toast.LENGTH_LONG,
      );

    }

    }

  }

  // ------------ get followers list -------------

  Future getFollowersList({required int pageKey, required int pageSize}) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      
      Response userData = await _dio.get('$URL/follow/getAllFollowers?page=$pageKey&limit=$pageSize', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      return userData.data;

    } on DioError catch (e) {

      if (e.response != null) {
    
        return e.response!.statusCode;

      } else {
        
        Fluttertoast.showToast(
          msg: 'Error getting followers list!',
          toastLength: Toast.LENGTH_LONG,
        );


        return e.message;
      }

    }
  }

  // ------------ End get followers list -------------

}