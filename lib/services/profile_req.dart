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
      print('bearer $bearerToken');
      
      Response userData = await _dio.get('$URL/users/me', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));
      print('User Info: ${userData.data}');
      print(userData.statusCode);
      print(userData.statusMessage);
      print(userData.headers);

      print('shit ${userData.data['data']['users']}');

      return userData.data['data']['users'];

    } on DioError catch (e) {

      if(e.type == DioErrorType.response) {
        print('bitch catched!');
      }

      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');

        // returning error status code
        return e.response!.statusCode;

      } else {
        print('Error sending request!');
        print(e.message);
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

      print('Users posts: ${userPosts.data}');
      print(userPosts.statusCode);
      print(userPosts.statusMessage);
      print(userPosts.headers);

      // // TODO: check that login again
      // if(userPosts.data['results'] == 0) {
      //   return 'empty posts';
      // }

      return userPosts.data;

    } on DioError catch (e) {

      if(e.type == DioErrorType.response) {
        print('bitch catched!');
      }

      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');

        // returning error status code
        return e.response!.statusCode;

      } else {
        print('Error sending request!');
        print(e.message);
        return e.message;
      }

    }

  }

  // ----------- End get user posts --------------------

  // ----------- get user profile details -------------

  Future getUserProfile({required String id}) async {

    try {


      final bearerToken = await SecureStorage.getToken() ?? '';
      print('bearer $bearerToken');
      
      Response userData = await _dio.get('$URL/users/$id', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));
      print('User profile Info: ${userData.data}');
      print(userData.statusCode);
      print(userData.statusMessage);
      print(userData.headers);

      return userData.data['data']['users'];

    } on DioError catch (e) {

      if(e.type == DioErrorType.response) {
        print('bitch catched!');
      }

      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');

        // returning error status code
        return e.response!.statusCode;

      } else {
        print('Error sending request!');
        print(e.message);
        return e.message;
      }

    }
  }

  // ----------- End get user profile details -------------

  // ------------ upload profile picture -------------

  Future uploadProfilePic(File file) async {

    String fileName = file.path.split('/').last;
    print('file $file');
    print('fileName $fileName');
    
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
      // .then((response) => print(response));
      // .catchError((error) => print(error));

      print('upload profilePic ' + response.statusCode.toString());


    } on DioError catch (e) {

    print('Error creating user: $e');

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

  // ------------ End upload profile picture -------------

  // ------------ upload cover picture -------------

  Future uploadCoverPic(File file) async {

    String fileName = file.path.split('/').last;
    print('file $file');
    print('fileName $fileName');
    
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
      // .then((response) => print(response));
      // .catchError((error) => print(error));

      print(response.statusCode);


    } on DioError catch (e) {

    print('Error creating user: $e');

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

  // ------------ End upload cover picture -------------

  // ------------ update bio -------------

  Future updateBio(String bio) async {

    // String fileName = file.path.split('/').last;
    print('Bio : $bio');
    
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
      // .then((response) => print(response));
      // .catchError((error) => print(error));

      print(response.statusCode);

      Fluttertoast.showToast(
        msg: 'Bio Updated!',
        toastLength: Toast.LENGTH_LONG,
      );


    } on DioError catch (e) {

    print('Error updating bio: $e');

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

  // ------------ End update bio -------------

  // ------------ update username -------------

  Future updateUsername(String username) async {

    // String fileName = file.path.split('/').last;
    print('Bio : $username');
    
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
      // .then((response) => print(response));
      // .catchError((error) => print(error));

      print(response.statusCode);

      Fluttertoast.showToast(
        msg: 'Username Updated!',
        toastLength: Toast.LENGTH_LONG,
      );


    } on DioError catch (e) {

    print('Error updating username: $e');

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

  // ------------ End update username -------------

  // ------------ get user by id -------------

  Future getUserById({required String id}) async {

    print('fucking id ' + id.toString());

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      print('bearer $bearerToken');
      
      Response userData = await _dio.get('$URL/users/$id', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));
      print('UserById info: ${userData.data}');
      print(userData.statusCode);
      print(userData.statusMessage);
      print(userData.headers);

      return userData.data['data']['users'];

    } on DioError catch (e) {

      if(e.type == DioErrorType.response) {
        print('bitch catched!');
      }

      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');

        // returning error status code
        return e.response!.statusCode;

      } else {
        print('Error sending request!');
        print(e.message);
        return e.message;
      }

    }
  }

  // ------------ End get user by id -------------

}