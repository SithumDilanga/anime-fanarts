import 'package:anime_fanarts/pagination_files/ui_constants.dart';
import 'package:anime_fanarts/post.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final dynamic postData;
  final List reactedPosts;

  const PostItem({Key? key, required this.postData, required this.reactedPosts}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool isReacted = false;
        
    // print('bitch ${snapshot.data['data']['reacted']}');
    print('reactedPosts $reactedPosts');

    for(int i = 0; i < reactedPosts.length; i++) {

      print('reacted posts ${reactedPosts}');

      if(reactedPosts[i]['post'] == postData['_id']) {

        isReacted = true;

        print('reacted shit ${postData['_id']}');

      }

    }

    return postData == LoadingIndicatorTitle
        ? CircularProgressIndicator()
        : Post(
            id: postData['_id'],
            name: postData['user']['name'],
            profilePic: '${postData['user']['profilePic']}',
            desc: postData['description'],
            postImg: postData['postImages'],
            userId: postData['user']['_id'],
            date: postData['createdAt'], //formattedDate,
            reactionCount: postData['reactions'][0]['reactionCount'],
            commentCount: postData['commentCount'][0]['commentCount'],
            isUserPost: false,
            isReacted: isReacted,
          );
  }
}