import 'package:anime_fanarts/pagination_files/creation_aware_list_item.dart';
import 'package:anime_fanarts/pagination_files/home_viewmodel.dart';
import 'package:anime_fanarts/pagination_files/list_item.dart';
import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/error_loading.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ExploreNew2 extends StatefulWidget {
  const ExploreNew2({ Key? key }) : super(key: key);

  @override
  _ExploreNew2State createState() => _ExploreNew2State();
}

class _ExploreNew2State extends State<ExploreNew2> with AutomaticKeepAliveClientMixin<ExploreNew2>{

  int pageNum = 1;
  List reactedPosts = [];
  List allPosts = [];

  // static const IMGURL = 'http://10.0.2.2:3000/img/users/';
  static const IMGURL = Urls.IMGURL;
  GetCreatePosts _getCreatePosts = GetCreatePosts();

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      print('_loadData');
    });
  }
  
  static const _pageSize = 10;

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

    return Scaffold(
      body: ChangeNotifierProvider<HomeViewModel>(
        create: (context) => HomeViewModel(),
        child: Consumer<HomeViewModel>(
          builder: (context, model, child) {

            return ListView.builder(
              itemCount: model.items.length,
              itemBuilder: (context, index) {

                // bool isReacted = false;
        
                // // print('bitch ${snapshot.data['data']['reacted']}');
                // print('reactedPosts $reactedPosts');
        
                // for(int i = 0; i < model.getReactedPosts.length; i++) {
        
                //   print('reacted posts ${model.getReactedPosts}');
        
                //   if(model.getReactedPosts[i]['post'] == model.items[index]['_id']) {
        
                //     isReacted = true;
        
                //     print('reacted shit ${model.items[index]['_id']}');
        
                //   }
        
                // }

                return CreationAwareListItem(
                  itemCreated: () {
                    SchedulerBinding.instance?.addPostFrameCallback(
                        (duration) => model.handleItemCreated(index));
                  },
                  child: ListItem(
                    PostData: model.items[index],
                    reactedPosts: model.getReactedPosts,
                  ),
                );
              }
            );
          }
        ),
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

class KeepAlive extends StatefulWidget {
  const KeepAlive({
    required Key key,
    required this.postData,
    required this.reactedPosts,
    required this.index
  }) : super(key: key);

  final dynamic postData;
  final List reactedPosts;
  final int index;

  @override
  State<KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  bool isReacted = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);        
              // print('bitch ${snapshot.data['data']['reacted']}');
    print('reactedPosts ${widget.reactedPosts}');
        
    for(int i = 0; i < widget.reactedPosts.length; i++) {
        
      // print('reacted posts ${reactedPosts[i]['post']}');
        
      if(widget.reactedPosts[i]['post'] == widget.postData['_id']) {
        
        print('reacted shitNew ${widget.reactedPosts[i]['post']}');
        isReacted = true;
        // 
        
      }
        
    }

    return Post(
      id: widget.postData['_id'],
      name: widget.postData['user']['name'],
      profilePic: '${widget.postData['user']['profilePic']}', //'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
      desc: widget.postData['description'],
      postImg: widget.postData['postImages'], //$IMGURL${allPosts[index]['postImages']}
      userId: widget.postData['user']['_id'],
      date: widget.postData['createdAt'], //formattedDate,
      reactionCount: widget.postData['reactions'][0]['reactionCount'],
      commentCount: widget.postData['commentCount'][0]['commentCount'],
      isUserPost: false,
      isReacted: isReacted,
    );
  }
}