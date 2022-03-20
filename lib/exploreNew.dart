import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/post_item.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExploreNew extends StatefulWidget {
  const ExploreNew({ Key? key }) : super(key: key);

  @override
  _ExploreNewState createState() => _ExploreNewState();
}

class _ExploreNewState extends State<ExploreNew> with AutomaticKeepAliveClientMixin<ExploreNew>{

  static const IMGURL = 'http://10.0.2.2:3000/img/users/';
  GetCreatePosts _getCreatePosts = GetCreatePosts();

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      print('_loadData');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.blue[200],
      backgroundColor: ColorTheme.primary,
      child: FutureBuilder(
        future: _getCreatePosts.getAllPostsNew(),
        builder: (context, AsyncSnapshot snapshot) {
    
          if(snapshot.hasData) {
    
            dynamic allPosts = snapshot.data['data']['posts'];
            dynamic reactedPosts = snapshot.data['data']['reacted'];

            print('reactedPosts $reactedPosts');

            // return ListView.custom(
            //   childrenDelegate: SliverChildBuilderDelegate(
            //     (BuildContext context, int index) {
            //       return KeepAlive(
            //         allPosts: allPosts,
            //         reactedPosts: reactedPosts,
            //         index: index,
            //         key: ValueKey<String>(index.toString()),
            //       );
            //     },
            //     childCount: allPosts.length,
            //   )
            // );

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

              // return PostItem(
              //   postData: allPosts[index], 
              //   reactedPosts: reactedPosts
              // );
    
              return Post(
                id: allPosts[index]['_id'],
                name: allPosts[index]['user']['name'],
                profilePic: '${allPosts[index]['user']['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
                desc: allPosts[index]['description'],
                postImg: allPosts[index]['postImages'], //$IMGURL${allPosts[index]['postImages']}
                userId: allPosts[index]['user']['_id'],
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


class KeepAlive extends StatefulWidget {
  const KeepAlive({
    required Key key,
    required this.allPosts,
    required this.reactedPosts,
    required this.index
  }) : super(key: key);

  final List allPosts;
  final List reactedPosts;
  final int index;

  @override
  State<KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bool isReacted = false;
    
    
    for(int i = 0; i < widget.reactedPosts.length; i++) {
    
      // print('reacted posts ${reactedPosts[i]['post']}');
    
      if(widget.reactedPosts[i]['post'] == widget.allPosts[widget.index]['_id']) {
    
        isReacted = true;
    
        print('reacted shit ${widget.allPosts[widget.index]['_id']}');
    
      }
    
    }

    return Post(
      id: widget.allPosts[widget.index]['_id'],
      name: widget.allPosts[widget.index]['user']['name'],
      profilePic: '${widget.allPosts[widget.index]['user']['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
      desc: widget.allPosts[widget.index]['description'],
      postImg: widget.allPosts[widget.index]['postImages'], //$IMGURL${allPosts[index]['postImages']}
      userId: widget.allPosts[widget.index]['user']['_id'],
      date: widget.allPosts[widget.index]['createdAt'], //formattedDate,
      reactionCount: widget.allPosts[widget.index]['reactions'][0]['reactionCount'],
      commentCount: widget.allPosts[widget.index]['commentCount'][0]['commentCount'],
      isUserPost: false,
      isReacted: isReacted,
    );
  }
}