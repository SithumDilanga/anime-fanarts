import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Explore extends StatefulWidget {
  const Explore({ Key? key }) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin<Explore>{

  static const IMGURL = 'http://10.0.2.2:3000/img/users/';
  GetCreatePosts _getCreatePosts = GetCreatePosts();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCreatePosts.getAllPosts(),
      builder: (context, AsyncSnapshot snapshot) {

        if(snapshot.hasData) {

          dynamic allPosts = snapshot.data['data']['posts'];
          dynamic reactedPosts = snapshot.data['data']['reacted'];

          return ListView.builder(
          itemCount: allPosts.length,
          itemBuilder: (context, index) {

            bool isReacted = false;

            print('bitch ${snapshot.data['data']['reacted']}');

            for(int i = 0; i < reactedPosts.length; i++) {

              // print('reacted posts ${reactedPosts[i]['post']}');

              if(reactedPosts[i]['post'] == allPosts[index]['_id']) {

                isReacted = true;

                print('reacted shit ${allPosts[index]['_id']}');

              }

            }

            // snapshot.data['data']['reacted'].map((reactedPost) {

            //   print('reacted posts $reactedPost');

            //   if(reactedPost['post'] == allPosts[index]['_id']) {

            //     isReacted = true;

            //     print('reacted shit ${allPosts[index]['_id']}');

            //   }

            // });

            return Post(
              id: allPosts[index]['_id'],
              name: allPosts[index]['user'][0]['name'],
              profilePic: '$IMGURL${allPosts[index]['user'][0]['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
              desc: allPosts[index]['description'],
              postImg: allPosts[index]['postImages'], //$IMGURL${allPosts[index]['postImages']}
              userId: allPosts[index]['user'][0]['_id'],
              date: allPosts[index]['createdAt'], //formattedDate,
              reactionCount: allPosts[index]['reactions'][0]['reactionCount'],
              commentCount: allPosts[index]['commentCount'][0]['commentCount'],
              isUserPost: false,
              isReacted: isReacted,
            );
          },
        );

        }

        return LoadingAnimation();

      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}