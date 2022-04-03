import 'package:anime_fanarts/models/reacted_posts.dart';
import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/error_loading.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  const Explore({ Key? key }) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with AutomaticKeepAliveClientMixin<Explore>{

  int pageNum = 1;
  List reactedPosts = [];
  List allPosts = [];

  GetCreatePosts _getCreatePosts = GetCreatePosts();
  
  static const _pageSize = 20;

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

    // print('pageKey $pageKey');
    // print('_pageSize $_pageSize');
    

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

    final reactedNewPosts = Provider.of<ReactedPosts>(context);

    reactedNewPosts.reactedPosts = reactedNewPosts.reactedPosts + reactedPosts;
    // reactedNewPosts.addReactedLists(reactedPosts);

    // for(int i = 0; i < reactedPosts.length; i++) {
    //   reactedNewPosts.addPostToReactedList(reactedPosts[i]['post']);
    // }

    return RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        color: Colors.blue[200],
        backgroundColor: ColorTheme.primary,
        child: PagedListView<int, dynamic>.separated(
          pagingController: _pagingController,
          addAutomaticKeepAlives: false,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            animateTransitions: true,
            itemBuilder: (context, item, index) {

              bool isReacted = false;
              bool isNewReacted = false;
        
              for(int j = 0; j < reactedNewPosts.reactedPosts.length; j++) {
                if(reactedNewPosts.reactedPosts[j] == item['_id']) {
                  isReacted = true;
                  isNewReacted = true;
                }
              }
        
              for(int i = 0; i < reactedPosts.length; i++) {
        
        
                if(reactedPosts[i]['post'] == item['_id']) {

                  if(reactedNewPosts.removedReactionList.isNotEmpty) {
                    for(int j = 0; j < reactedNewPosts.removedReactionList.length; j++) {
                      if(reactedNewPosts.removedReactionList.elementAt(j) != item['_id']) {
                        isReacted = true;
                      }
                    }
                  } else {
                    
                    isReacted = true;
                  }
        
                  // isReacted = true;
                
                } 

                
        
              }

              return Post(
                id: item['_id'],
                name: item['user']['name'],
                profilePic: '${item['user']['profilePic']}', 
                desc: item['description'],
                postImg: item['postImages'],
                userId: item['user']['_id'],
                date: item['createdAt'], //formattedDate,
                reactionCount: item['reactions'][0]['reactionCount'],
                commentCount: item['commentCount'][0]['commentCount'],
                isUserPost: false,
                isReacted: isReacted,
                // reactedPosts: reactedPosts

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
