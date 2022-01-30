import 'package:anime_fanarts/models/reaction.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Interactions {

  var _dio = Dio();
  static const URL = 'http://10.0.2.2:3000/api/v1';

  Future createReaction({required Reaction reaction}) async {

    Response userReaction;

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      
      userReaction = await _dio.post(
        '$URL/reactions', 
        data: reaction.toJson(), 
        options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      print('create reaction: ${userReaction.data}');
      print(userReaction.statusCode);
      print(userReaction.statusMessage);
      print(userReaction.headers);

      Fluttertoast.showToast(
        msg: 'reaction added!',
        toastLength: Toast.LENGTH_LONG,
      );


      return userReaction.data['data'];

    } on DioError catch (e) {

      print('Error creating reaction : $e');

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

}