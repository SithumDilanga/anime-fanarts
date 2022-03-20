import 'package:anime_fanarts/pagination_files/ui_constants.dart';
import 'package:anime_fanarts/post.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final dynamic PostData;
  final List reactedPosts;
  const ListItem({Key? key, required this.PostData, required this.reactedPosts}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool isReacted = false;
        
    // print('bitch ${snapshot.data['data']['reacted']}');
    print('reactedPosts $reactedPosts');

    for(int i = 0; i < reactedPosts.length; i++) {

      print('reacted posts ${reactedPosts}');

      if(reactedPosts[i]['post'] == PostData['_id']) {

        isReacted = true;

        print('reacted shit ${PostData['_id']}');

      }

    }

    return PostData == LoadingIndicatorTitle
        ? CircularProgressIndicator()
        : Post(
            id: PostData['_id'],
            name: PostData['user']['name'],
            profilePic: '${PostData['user']['profilePic']}',
            desc: PostData['description'],
            postImg: PostData['postImages'],
            userId: PostData['user']['_id'],
            date: PostData['createdAt'], //formattedDate,
            reactionCount: PostData['reactions'][0]['reactionCount'],
            commentCount: PostData['commentCount'][0]['commentCount'],
            isUserPost: false,
            isReacted: isReacted,
          );
  }
}
