
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BlockUserReq {

  var _dio = Dio();
  static const URL = Urls.apiUrl;

  // --------------- send blocked user -----------------

  Future sendBlockedUser(String? blockedUserId, String? blockedUserName) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      // final blockedUsersList = SharedPref.getBlockedUserIdsList() ?? [];
      
      Response blockedUser = await _dio.post('$URL/blocked',
      data: {
        'blockedUser': blockedUserId,
        'name': blockedUserName
      },
      options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      if(blockedUser.statusCode == 200) {

        Fluttertoast.showToast(
          msg: 'Successfully blocked the user!',
          toastLength: Toast.LENGTH_LONG,
        );

      }

      return blockedUser.data;

    } on DioError catch (e) {

      if (e.response != null) {

        // return e.response!.statusCode;

        Fluttertoast.showToast(
          msg: 'Error bloacking user!',
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

  // --------------- End send blocked user -----------------


  // --------------- get blocked users -----------------

  Future getBlockedUsers({required bool isWhenLogin}) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      // final blockedUsersList = SharedPref.getBlockedUserIdsList() ?? [];
      
      Response blockedUsers = await _dio.get('$URL/blocked',
      options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      if(isWhenLogin) {

        SharedPref.removeSpecificCache('blockedUserIds').whenComplete(() {

          for(int i = 0; i < blockedUsers.data['data']['blocklist'].length; i++) {

            SharedPref.setBlockedUserIdsList(
              blockedUserId: blockedUsers.data['data']['blocklist'][i]['blockedUser'],
            );

            print('loggingBlockedUsers ${blockedUsers.data['data']['blocklist'][i]['blockedUser']}');

          }

        });

      }

      return blockedUsers.data;

    } on DioError catch (e) {

      if (e.response != null) {

        // return e.response!.statusCode;

        Fluttertoast.showToast(
          msg: 'Error getting blocked users!',
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

  // --------------- End get blocked users -----------------


  // --------------- unblock a user -----------------

  Future unblockUser(String? blockedUserId) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';

      // final blockedUsersList = SharedPref.getBlockedUserIdsList() ?? [];
      
      Response unblockedUser = await _dio.delete('$URL/blocked',
      data: {
        'blockedUser': blockedUserId,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      if(unblockedUser.statusCode == 200) {

        Fluttertoast.showToast(
          msg: 'Successfully unblocked the user!',
          toastLength: Toast.LENGTH_LONG,
        );

      }

      return unblockedUser.data;

    } on DioError catch (e) {

      if (e.response != null) {

        // return e.response!.statusCode;

        Fluttertoast.showToast(
          msg: 'Error ublocking the users!',
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

  // --------------- End unblock a user -----------------

}