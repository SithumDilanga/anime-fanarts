import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/error_loading.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({ Key? key }) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with AutomaticKeepAliveClientMixin<ExplorePage>{

  int pageNum = 1;
  List reactedPosts = [];
  List allPosts = [];
  
  GetCreatePosts _getCreatePosts = GetCreatePosts();
  
  static const _pageSize = 10;

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1,);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  void _fetchPage(int pageKey) async {
    
    // API request
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
        int nextPageKey = (pageKey + 1);
        _pagingController.appendPage(newItems, nextPageKey);
      }
      
      setState(() {
        reactedPosts = reactedPosts + allPostsData['data']['reacted'];
        allPosts = allPosts + allPostsData['data']['posts'];
      });

    } catch (error) {
      _pagingController.error = error;
    }

  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);  

    return RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        color: Colors.blue[200],
        backgroundColor: ColorTheme.primary,
        child: PagedListView<int, dynamic>.separated(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            animateTransitions: true,
            itemBuilder: (context, item, index) {

              bool isReacted = false;
      
              print('reactedPosts $reactedPosts');
        
              for(int i = 0; i < reactedPosts.length; i++) {
        
        
                if(reactedPosts[i]['post'] == item['_id']) {
        
                  isReacted = true;
        
                  print('reacted shit ${item['_id']}');
        
                }
        
              }

              return Post(
                id: item['_id'],
                name: item['user']['name'],
                profilePic: '${item['user']['profilePic']}', 
                desc: item['description'],
                postImg: item['postImages'],
                userId: item['user']['_id'],
                date: item['createdAt'], 
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

  }

  @override
  bool get wantKeepAlive => true;
}