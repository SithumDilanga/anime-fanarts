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

      return userReaction.data['data'];

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
          msg: 'Error sending request!',
          toastLength: Toast.LENGTH_LONG,
        );

      }

      }

  }

  // ------------ End create reaction ----------------

  // ------------ get comments ----------------

  Future getComments(String? postId, int pageKey, int pageSize) async {

    try {

      final bearerToken = await SecureStorage.getToken() ?? '';
      
      Response allComments = await _dio.get('$URL/comments?page=$pageKey&limit=$pageSize&postId=$postId', options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));
  

      return allComments.data;

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
          msg: 'Error loading comments!',
          toastLength: Toast.LENGTH_LONG,
        );

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
      
      Response addComment = await _dio.post('$URL/comments?page=1&limit=20&postId=$postId', data: {
        'comment': commentText,
        'post': postId,
      } , options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      return addComment.data['data']['comment'];

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
          msg: 'Error sending request!',
          toastLength: Toast.LENGTH_LONG,
        );
      }

    }

  }

  // ------------ End add a new comment ----------------


  // ------------ add a new comment reply ----------------

  Future addNewReplyComment({String? commentText, String? commentId, String? postId, String? replyMention}) async {

    try {

      // FormData data = FormData.fromMap({
      //   'comment':  commentText,
      //   'post': postId
      // });

      final bearerToken = await SecureStorage.getToken() ?? '';
      
      Response addComment = await _dio.post('$URL/comments/replyComment', data: {
        'comment': commentText,
        'commentId': commentId,
        'postId': postId,
        'replyMention': replyMention
      } , options: Options(
        headers: {'Authorization': 'Bearer $bearerToken'},
      ));

      return addComment.data['status'];

    } on DioError catch (e) {


      if (e.response != null) {

        Fluttertoast.showToast(
          msg: 'Error replying to the comment!',
          toastLength: Toast.LENGTH_LONG,
        );

        // throw Error();
        throw(e.response!.data['message']);

      } else {

        Fluttertoast.showToast(
          msg: 'Error sending request!',
          toastLength: Toast.LENGTH_LONG,
        );
      }

    }

  }

  // ------------ End add a new comment reply ----------------

}