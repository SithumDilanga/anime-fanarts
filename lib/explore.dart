import 'package:anime_fanarts/models/new_post_refresher.dart';
import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/error_loading.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  const Explore({ Key? key }) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin<Explore>{

  int pageNum = 1;
  List allPosts = [];
  List reactedPosts = [];

  // static const IMGURL = 'http://10.0.2.2:3000/img/users/';
  static const IMGURL = Urls.IMGURL;
  GetCreatePosts _getCreatePosts = GetCreatePosts();

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      print('_loadData');
    });
  }
  
  static const _pageSize = 9;

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  void _fetchReactedPosts(int pageKey) async {

    final allPostsData = await _getCreatePosts.getAllPosts(
      pageKey,
      3
    );

    print('nigga ${allPostsData['data']['reacted']}');

    setState(() {
      reactedPosts = allPostsData['data']['reacted'];
    });


  }

  void _fetchPage(int pageKey) async {

    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    print('nativetimezone $currentTimeZone');

    print('pageKey $pageKey');
    print('_pageSize $_pageSize');
    
    // Response allPostsData = await _dio.get('$URL/posts?page=$pageKey&limit=$_pageSize', options: Options(
    //   headers: {'Authorization': 'Bearer $bearerToken'},
    // ));

    final allPostsData = await _getCreatePosts.getAllPosts(
      pageKey,
      _pageSize
    );

     try {
      final newItems = await allPostsData['data']['posts'];

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // int nextPageKey = (pageKey + newItems.length) as int;
        int nextPageKey = (pageKey + 1);
        _pagingController.appendPage(newItems, nextPageKey);
      }

      setState(() {
        reactedPosts = reactedPosts + allPostsData['data']['reacted'];
        print('reactedPosts2 $reactedPosts');
      });

      print('reactedPosts1 $allPostsData');

    } catch (error) {
      _pagingController.error = error;
    }

      // final isLastPage = newItems.length < _pageSize;
      // if (isLastPage) {
      //   _pagingController.appendLastPage(newItems);
      // } else {
      //   final nextPageKey = pageKey + newItems.length;
      //   _pagingController.appendPage(newItems, nextPageKey);
      // }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    dynamic reactedNewPosts = reactedPosts; 

    return RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, dynamic>.separated(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            animateTransitions: true,
            itemBuilder: (context, item, index) {

              // dynamic reactedPosts = snapshot.data['data']['reacted'];

              bool isReacted = false;
        
              // print('bitch ${snapshot.data['data']['reacted']}');
              print('reactedPosts $reactedNewPosts');
        
              for(int i = 0; i < reactedNewPosts.length; i++) {
        
                // print('reacted posts ${reactedPosts[i]['post']}');
        
                if(reactedNewPosts[i]['post'] == item['_id']) {
        
                  isReacted = true;
        
                  print('reacted shit ${item['_id']}');
        
                }
        
              }

              return Post(
                id: item['_id'],
                name: item['user'][0]['name'],
                profilePic: '$IMGURL${item['user'][0]['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
                desc: item['description'],
                postImg: item['postImages'], //$IMGURL${allPosts[index]['postImages']}
                userId: item['user'][0]['_id'],
                date: item['createdAt'], //formattedDate,
                reactionCount: item['reactions'][0]['reactionCount'],
                commentCount: item['commentCount'][0]['commentCount'],
                isUserPost: false,
                isReacted: isReacted,
              );
            },
            firstPageErrorIndicatorBuilder: (context) => ErrorLoading(
              errorMsg: 'Error loading posts: code #001', 
              onTryAgain: _pagingController.refresh
            ) 
            ,
            noItemsFoundIndicatorBuilder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'No posts to show!',
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                ),
              ),
            ),
            newPageErrorIndicatorBuilder: (context) => ErrorLoading(
              errorMsg: 'Error loading posts: code #002', 
              onTryAgain: _pagingController.refresh
            ),
            firstPageProgressIndicatorBuilder: (context) => LoadingAnimation(),
            newPageProgressIndicatorBuilder: (context) => LoadingAnimation(),
            noMoreItemsIndicatorBuilder: (context) => 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'No posts to show!',
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                ),
              ),
            )
          ),
          separatorBuilder: (context, index) => const Divider(height: 0,),
        ),
      );

    // return PagedListView<dynamic, dynamic>(
    //   pagingController: _pagingController,
    //   builderDelegate: PagedChildBuilderDelegate<dynamic>(
    //     itemBuilder: (context, item, index) { 

    //       print('item $item');

    //       return Post(
    //         id: item['_id'],
    //         name: item['user'][0]['name'],
    //         profilePic: '$IMGURL${item['user'][0]['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
    //         desc: item['description'],
    //         postImg: item['postImages'], //$IMGURL${allPosts[index]['postImages']}
    //         userId: item['user'][0]['_id'],
    //         date: item['createdAt'], //formattedDate,
    //         reactionCount: item['reactions'][0]['reactionCount'],
    //         commentCount: item['commentCount'][0]['commentCount'],
    //         isUserPost: false,
    //         isReacted: false,
    //       );
    //     }
    //    //  Text(
    //    //    '${item['description']}'
    //    //  ),
       
    //   ),
    // );

    // return RefreshIndicator(
    //   onRefresh: _loadData,
    //   color: Colors.blue[200],
    //   backgroundColor: ColorTheme.primary,
    //   child: FutureBuilder(
    //     future: _getCreatePosts.getAllPosts(pageNum),
    //     builder: (context, AsyncSnapshot snapshot) {
        
    //       if(snapshot.hasData) {
        
    //         dynamic allPosts = snapshot.data['data']['posts'];
    //         dynamic reactedPosts = snapshot.data['data']['reacted'];
        
             

    //         return ListView.builder(
    //         itemCount: allPosts.length,
    //         itemBuilder: (context, index) {
        
    //           bool isReacted = false;
        
    //           print('bitch ${snapshot.data['data']['reacted']}');
        
    //           for(int i = 0; i < reactedPosts.length; i++) {
        
    //             // print('reacted posts ${reactedPosts[i]['post']}');
        
    //             if(reactedPosts[i]['post'] == allPosts[index]['_id']) {
        
    //               isReacted = true;
        
    //               print('reacted shit ${allPosts[index]['_id']}');
        
    //             }
        
    //           }
        
    //           // snapshot.data['data']['reacted'].map((reactedPost) {
        
    //           //   print('reacted posts $reactedPost');
        
    //           //   if(reactedPost['post'] == allPosts[index]['_id']) {
        
    //           //     isReacted = true;
        
    //           //     print('reacted shit ${allPosts[index]['_id']}');
        
    //           //   }
        
    //           // });
        
    //           return Post(
    //             id: allPosts[index]['_id'],
    //             name: allPosts[index]['user'][0]['name'],
    //             profilePic: '$IMGURL${allPosts[index]['user'][0]['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
    //             desc: allPosts[index]['description'],
    //             postImg: allPosts[index]['postImages'], //$IMGURL${allPosts[index]['postImages']}
    //             userId: allPosts[index]['user'][0]['_id'],
    //             date: allPosts[index]['createdAt'], //formattedDate,
    //             reactionCount: allPosts[index]['reactions'][0]['reactionCount'],
    //             commentCount: allPosts[index]['commentCount'][0]['commentCount'],
    //             isUserPost: false,
    //             isReacted: isReacted,
    //           );
    //         },
    //       );
        
    //       }
        
    //       return LoadingAnimation();
        
    //     }
    //   ),
    // );
  }

  @override
  bool get wantKeepAlive => true;
}