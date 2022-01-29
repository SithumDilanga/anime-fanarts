import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/services/get_posts.dart';
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
  GetPosts _getPosts = GetPosts();

  // convert MongoDB createdAt into Datetime
  getFormattedDateFromFormattedString(
      {required value,
      required String currentFormat,
      required String desiredFormat,
      isUtc = false}) {
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      try {
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
      } catch (e) {
        print("$e");
      }
    }
    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPosts.getAllPosts(),
      builder: (context, AsyncSnapshot snapshot) {

        if(snapshot.hasData) {

          dynamic allPosts = snapshot.data['posts'];

          return ListView.builder(
          itemCount: allPosts.length,
          itemBuilder: (context, index) {

            print('fucking image $IMGURL${allPosts[index]['postImages']}');


            DateTime dateTime = getFormattedDateFromFormattedString(
              value: allPosts[index]['createdAt'],
              currentFormat: "yyyy-MM-ddTHH:mm:ssZ",
              desiredFormat: "yyyy-MM-dd HH:mm"
            );

            String formattedDate = DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);

            print('dateTime ' + formattedDate.toString()); //2021-12-15 11:10:01.000

            return Post(
              id: allPosts[index]['_id'],
              name: allPosts[index]['user'][0]['name'],
              profilePic: '$IMGURL${allPosts[index]['user'][0]['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
              desc: allPosts[index]['description'],
              postImg: allPosts[index]['postImages'], //$IMGURL${allPosts[index]['postImages']}
              userId: allPosts[index]['user'][0]['_id'],
              date: formattedDate,
              reactionCount: allPosts[index]['reactions'][0]['reactionCount'],
              commentCount: allPosts[index]['commentCount'][0]['commentCount'],
              isUserPost: false
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