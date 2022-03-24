import 'package:anime_fanarts/models/reacted_posts.dart';
import 'package:anime_fanarts/pagination_files/list_item.dart';
import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/post_item.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/error_loading.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
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

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      print('_loadData');
    });
  }
  
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
        //TODO: reaction not updating issue. this line is the issue
        reactedPosts = reactedPosts + allPostsData['data']['reacted'];
        allPosts = allPosts + allPostsData['data']['posts'];
        print('reactedReal ${reactedPosts.length}');
        print('reactedPosts2bitch ${allPosts.length}');
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
    // dynamic reactedNewPosts = reactedPosts; 

    // print('reactedNewPosts $reactedPosts');

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
          // addAutomaticKeepAlives: false,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            animateTransitions: true,
            itemBuilder: (context, item, index) {

              print('removedReactionList ${reactedNewPosts.removedReactionList}');

              // dynamic reactedPosts = snapshot.data['data']['reacted'];

              bool isReacted = false;
              bool isNewReacted = false;
        
              // print('bitch ${snapshot.data['data']['reacted']}');
              print('reactedPosts $reactedPosts');

              for(int j = 0; j < reactedNewPosts.reactedPosts.length; j++) {
                if(reactedNewPosts.reactedPosts[j] == item['_id']) {
                  isReacted = true;
                  isNewReacted = true;
                  print('reactedNewPosts.reactedPosts[j] ${reactedNewPosts.reactedPosts[j]}');
                }
              }
        
              for(int i = 0; i < reactedPosts.length; i++) {
        
                // print('reacted posts ${reactedPosts[i]['post']}');
        
                if(reactedPosts[i]['post'] == item['_id']) {

                  if(reactedNewPosts.removedReactionList.isNotEmpty) {
                    for(int j = 0; j < reactedNewPosts.removedReactionList.length; j++) {
                      print('whatsinthere ${reactedNewPosts.removedReactionList.elementAt(j)}');
                      if(reactedNewPosts.removedReactionList.elementAt(j) != item['_id']) {
                        isReacted = true;
                      }
                    }
                  } else {
                    print('whaddahell');
                    
                    isReacted = true;
                  }
        
                  // isReacted = true;
        
                  print('reacted shit ${item['_id']}');
        
                } 

                
        
              }

              // for(int j = 0; j < reactedNewPosts.reactedPosts.length; j++) {
              //   if(reactedNewPosts.reactedPosts[j] == item['_id']) {
              //     isReacted = true;
              //     print('reactedNewPosts.reactedPosts[j] ${reactedNewPosts.reactedPosts[j]}');
              //   }
              // }

              // return PostItem(
              //   postData: item,
              //   reactedPosts: reactedPosts,
              // );

              // return Container(
              //   child: ListItem(
              //     PostData: item, 
              //     reactedPosts: reactedPosts
              //   ),
              // );

              // return KeepAlive(
              //   postData: item,
              //   reactedPosts: reactedPosts,
              //   index: index,
              //   key: ValueKey<String>(index.toString()),
              // );

              // return KeepAlive(
              //   postData: item,
              //   isReacted: isReacted,
              //   index: index,
              //   key: ValueKey<String>(index.toString()),
              // );

              return Post(
                id: item['_id'],
                name: item['user']['name'],
                profilePic: '${item['user']['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
                desc: item['description'],
                postImg: item['postImages'], //$IMGURL${allPosts[index]['postImages']}
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

// class KeepAlive extends StatefulWidget {
//   const KeepAlive({
//     required Key key,
//     required this.postData,
//     required this.isReacted,
//     required this.index
//   }) : super(key: key);

//   final dynamic postData;
//   final bool isReacted;
//   final int index;

//   @override
//   State<KeepAlive> createState() => _KeepAliveState();
// }

// class _KeepAliveState extends State<KeepAlive> with AutomaticKeepAliveClientMixin{
//   @override
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return Post(
//       id: widget.postData['_id'],
//       name: widget.postData['user']['name'],
//       profilePic: '${widget.postData['user']['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
//       desc: widget.postData['description'],
//       postImg: widget.postData['postImages'], //$IMGURL${allPosts[index]['postImages']}
//       userId: widget.postData['user']['_id'],
//       date: widget.postData['createdAt'], //formattedDate,
//       reactionCount: widget.postData['reactions'][0]['reactionCount'],
//       commentCount: widget.postData['commentCount'][0]['commentCount'],
//       isUserPost: false,
//       isReacted: widget.isReacted,
//     );
//   }
// }

// class KeepAlive extends StatefulWidget {
//   const KeepAlive({
//     required Key key,
//     required this.postData,
//     required this.reactedPosts,
//     required this.index
//   }) : super(key: key);

//   final dynamic postData;
//   final List reactedPosts;
//   final int index;

//   @override
//   State<KeepAlive> createState() => _KeepAliveState();
// }

// class _KeepAliveState extends State<KeepAlive> with AutomaticKeepAliveClientMixin{
//   @override
//   bool get wantKeepAlive => true;

//   bool isReacted = false;

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);        
//               // print('bitch ${snapshot.data['data']['reacted']}');
//     print('reactedPosts ${widget.reactedPosts}');
        
//     for(int i = 0; i < widget.reactedPosts.length; i++) {
        
//       // print('reacted posts ${reactedPosts[i]['post']}');
        
//       if(widget.reactedPosts[i]['post'] == widget.postData['_id']) {
        
//         print('reacted shitNew ${widget.reactedPosts[i]['post']}');
//         isReacted = true;
//         // 
        
//       }
        
//     }

//     return Post(
//       id: widget.postData['_id'],
//       name: widget.postData['user']['name'],
//       profilePic: '${widget.postData['user']['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
//       desc: widget.postData['description'],
//       postImg: widget.postData['postImages'], //$IMGURL${allPosts[index]['postImages']}
//       userId: widget.postData['user']['_id'],
//       date: widget.postData['createdAt'], //formattedDate,
//       reactionCount: widget.postData['reactions'][0]['reactionCount'],
//       commentCount: widget.postData['commentCount'][0]['commentCount'],
//       isUserPost: false,
//       reactedPosts: widget.reactedPosts//isReacted,
//     );
//   }
// }