import 'package:anime_fanarts/models/user_login.dart';
import 'package:anime_fanarts/models/user_sign_up.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthReq {

  var _dio = Dio();
  // static const URL = 'http://10.0.2.2:3000/api/v1';
  static const URL = Urls.apiUrl;

  Future signUp({required UserSignUp userSignUp}) async {

    UserSignUp? retrievedUser;
    Response? response;

    try {

      //http://10.0.2.2:3000/users/signup
      response = await _dio.post(
        '$URL/users/signup',
        data: userSignUp.toJson(),
      );

      print('User created: ${response.data}');
      print('token: ${response.data['token']}');

      SecureStorage.setToken(response.data['token']);
      SecureStorage.setUserId(response.data['data']['user']['_id']);

      retrievedUser = UserSignUp.fromJson(response.data);

    } on DioError catch (e) {
      print('Error creating user: $e');

      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');

        // return e.response!.statusCode;

        if(e.response!.data['error']['code'] == 11000) {

          Fluttertoast.showToast(
            msg: 'Email or username already exits!',
            toastLength: Toast.LENGTH_LONG,
          );
        }

        Fluttertoast.showToast(
          msg: e.response!.data['message'],
          toastLength: Toast.LENGTH_SHORT,
        );

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

    return retrievedUser;
  }

  // ------------ login ---------------

  //<UserLogin?>
  Future loginUser({required UserLogin userLogin}) async {

  UserLogin? retrievedUser;
  Response response;

  try {
    response = await _dio.post(
      '$URL/users/login',
      data: userLogin.toJson(),
    );

    print('User created: ${response.statusCode}');
    print('User Info: ${response.data}');
    print('token: ${response.data['token']}');

    SecureStorage.setToken(response.data['token']);
    SecureStorage.setUserId(response.data['data']['user']['_id']);
    
    retrievedUser = UserLogin.fromJson(response.data);

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
  return retrievedUser;
  }

// ------------ End login ---------------


// ------------ forgot password ---------------

  Future forgotPassword(String email) async {

  Response response;

  try {

    response = await _dio.post(
      '$URL/users/forgotPassword',
      data: {
        'email': email 
      },
    );

    print('forgot password: ${response.statusCode}');
    print('forgot password: ${response.data}');

    return response.statusCode;
    

  } on DioError catch (e) {

    print('Error sending verifcation code: $e');

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

// ------------ End forgot password ---------------


// ------------ reset password ---------------

  Future resetPassword(String email, String otpCode, String password, String confirmPassword) async {

  Response response;

  try {

    response = await _dio.patch(
      '$URL/users/resetPassword',
      data: {
        'token': otpCode,
        'email': email,
        'password': password,
        'passwordConfirm': confirmPassword
         
      },
    );

    print('reset password: ${response.statusCode}');
    print('reset password: ${response.data}');

    SecureStorage.setToken(response.data['token']);
    SecureStorage.setUserId(response.data['data']['user']['_id']);

    return response.statusCode;
    

  } on DioError catch (e) {

    print('Error sending verifcation code: $e');

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

// ------------ End reset password ---------------

}