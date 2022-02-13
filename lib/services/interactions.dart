import 'package:anime_fanarts/models/reaction.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Interactions {

  var _dio = Dio();
  // static const URL = 'http://10.0.2.2:3000/api/v1';
  static const URL = Urls.apiUrl;

  // ------------ create reaction ----------------

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

  // ------------ End create reaction ----------------

  // ------------ get comments ----------------

  Future getComments(String? postId) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      print('bearer $bearerToken');
      
      Response allComments = await _dio.get('$URL/comments?page=1&limit=20&postId=$postId', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));
      print('All comments: ${allComments.data}');
      print(allComments.statusCode);
      print(allComments.statusMessage);
      print(allComments.headers);

      print('shit ${allComments.data['data']['comments']}');

      return allComments.data['data']['comments'];

    } on DioError catch (e) {

      print('Error getting comments : $e');

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

  // ------------ End get comments ----------------

  // ------------ add a new comment ----------------

  Future addNewComment(String? commentText, String? postId) async {

    try {

      // FormData data = FormData.fromMap({
      //   'comment':  commentText,
      //   'post': postId
      // });

      final bearerToken = await SecureStorage.getToken() ?? '';
      print('bearer $bearerToken');
      
      Response addComment = await _dio.post('$URL/comments?page=1&limit=20&postId=$postId', data: {
        'comment': commentText,
        'post': postId
      } , options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));
      print('add a comment: ${addComment.data}');
      print(addComment.statusCode);
      print(addComment.statusMessage);
      print(addComment.headers);

      print('shit ${addComment.data['data']['comment']}');

      return addComment.data['data']['comment'];

    } on DioError catch (e) {

      print('Error getting comments : $e');

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

  // ------------ End get comments ----------------

}