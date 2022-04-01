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

      SecureStorage.setToken(response.data['token']);
      SecureStorage.setUserId(response.data['data']['user']['_id']);
      SharedPref.setUserName(response.data['data']['user']['name']);

      retrievedUser = UserSignUp.fromJson(response.data);

      Fluttertoast.showToast(
        msg: 'Successfully signed up!',
        toastLength: Toast.LENGTH_LONG,
      );

    } on DioError catch (e) {

      if (e.response != null) {

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

    SecureStorage.setToken(response.data['token']);
    SecureStorage.setUserId(response.data['data']['user']['_id']);
    SharedPref.setUserName(response.data['data']['user']['name']);
    
    retrievedUser = UserLogin.fromJson(response.data);

    Fluttertoast.showToast(
      msg: 'Successfully logged in!',
      toastLength: Toast.LENGTH_LONG,
    );

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
        msg: e.message,
        toastLength: Toast.LENGTH_LONG,
      );
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

    return response.statusCode;
    

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
        msg: e.message,
        toastLength: Toast.LENGTH_LONG,
      );

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

    SecureStorage.setToken(response.data['token']);
    SecureStorage.setUserId(response.data['data']['user']['_id']);

    return response.statusCode;
    

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
        msg: e.message,
        toastLength: Toast.LENGTH_LONG,
      );
    }

    }
  
  }

// ------------ End reset password ---------------

}