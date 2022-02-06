import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Explore extends StatefulWidget {
  const Explore({ Key? key }) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin<Explore>{

  int pageNum = 1;
  List allPosts = [];

  static const IMGURL = 'http://10.0.2.2:3000/img/users/';
  GetCreatePosts _getCreatePosts = GetCreatePosts();

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      print('_loadData');
    });
  }
  
  static const _pageSize = 20;

  final PagingController<dynamic, dynamic> _pagingController =
      PagingController(firstPageKey: 0);

   @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  void _fetchPage(int pageKey) async {

    var _dio = Dio();
    const URL = 'http://10.0.2.2:3000/api/v1';

    final bearerToken = await SecureStorage.getToken() ?? '';
    
    Response allPostsData = await _dio.get('$URL/posts?page=$_pageSize&limit=3', options: Options(
      headers: {'Authorization': 'Bearer $bearerToken'},
    ));

    allPostsData.data.then((newItems) {
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    }).catchError((error) {
      _pagingController.error = error;
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.blue[200],
      backgroundColor: ColorTheme.primary,
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: FutureBuilder(
              future: _getCreatePosts.getAllPosts(pageNum),
              builder: (context, AsyncSnapshot snapshot) {
              
                if(snapshot.hasData) {
              
                  dynamic allPosts = snapshot.data['data']['posts'];
                  dynamic reactedPosts = snapshot.data['data']['reacted'];
              
                   return PagedListView<dynamic, dynamic>(
                     pagingController: _pagingController,
                     builderDelegate: PagedChildBuilderDelegate<dynamic>(
                       itemBuilder: (context, item, index) => Text(
                         '$item'
                       ),
                     ),
                   );

                //   return ListView.builder(
                //   itemCount: allPosts.length,
                //   itemBuilder: (context, index) {
              
                //     bool isReacted = false;
              
                //     print('bitch ${snapshot.data['data']['reacted']}');
              
                //     for(int i = 0; i < reactedPosts.length; i++) {
              
                //       // print('reacted posts ${reactedPosts[i]['post']}');
              
                //       if(reactedPosts[i]['post'] == allPosts[index]['_id']) {
              
                //         isReacted = true;
              
                //         print('reacted shit ${allPosts[index]['_id']}');
              
                //       }
              
                //     }
              
                //     // snapshot.data['data']['reacted'].map((reactedPost) {
              
                //     //   print('reacted posts $reactedPost');
              
                //     //   if(reactedPost['post'] == allPosts[index]['_id']) {
              
                //     //     isReacted = true;
              
                //     //     print('reacted shit ${allPosts[index]['_id']}');
              
                //     //   }
              
                //     // });
              
                //     return Post(
                //       id: allPosts[index]['_id'],
                //       name: allPosts[index]['user'][0]['name'],
                //       profilePic: '$IMGURL${allPosts[index]['user'][0]['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
                //       desc: allPosts[index]['description'],
                //       postImg: allPosts[index]['postImages'], //$IMGURL${allPosts[index]['postImages']}
                //       userId: allPosts[index]['user'][0]['_id'],
                //       date: allPosts[index]['createdAt'], //formattedDate,
                //       reactionCount: allPosts[index]['reactions'][0]['reactionCount'],
                //       commentCount: allPosts[index]['commentCount'][0]['commentCount'],
                //       isUserPost: false,
                //       isReacted: isReacted,
                //     );
                //   },
                // );
              
                }
              
                return LoadingAnimation();
              
              }
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(
                Icons.replay_outlined
              ),
              onPressed: () {

                setState(() {
                  pageNum = 2;
                });

              }, 
            ) 
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}