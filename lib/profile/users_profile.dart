import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/services/profile_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/error_loading.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

class UsersProfile extends StatefulWidget {

  final String? name;
  final String? userId;

  const UsersProfile({ Key? key, required this.name, required this.userId, }) : super(key: key);

  @override
  UsersProfileState createState() => UsersProfileState();
}

class UsersProfileState extends State<UsersProfile> with AutomaticKeepAliveClientMixin<UsersProfile> {

  static const animuzuId = Urls.animuzuUserId;

  static const _pageSize = 8;
   List reactedPosts = [];
   dynamic userInfo = {
     "profilePic": "default-profile-pic.jpg",
     "coverPic": "default-cover-pic.png",
     "name": "Loading...",
   };

  final PagingController<int, dynamic> _pagingController = PagingController(firstPageKey: 1);

  ProfileReq _profileReq = ProfileReq();

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      print('_loadData');
    });
  }

   void _fetchPage(int pageKey) async {

     final allPostsData = await _profileReq.getUserById(
       id: '${widget.userId}',
       pageKey: pageKey,
       pageSize: _pageSize
     );

     try {  

      final newItems = await allPostsData['posts']['posts'];
      print('nativetimezoneProfile ${allPostsData['data']['user']}');

      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // int nextPageKey = (pageKey + newItems.length) as int;
        int nextPageKey = (pageKey + 1);
        _pagingController.appendPage(newItems, nextPageKey);
      }

      setState(() {
        print('yoyo! $reactedPosts');
        reactedPosts = reactedPosts + allPostsData['reacted'];
        userInfo = allPostsData['data']['user'];
        print('yoyo!2 $userInfo');
        // allPosts = allPostsData;
      });

    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // dynamic reactedNewPosts = reactedPosts; 
    // dynamic userInfo = userDetails; 

    return RefreshIndicator(
      onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
      ),
      color: Colors.blue[200],
      backgroundColor: ColorTheme.primary,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorTheme.primary,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded
              ),
              onPressed: () {
                Navigator.pop(context);
              }, 
            ),
            title: Text(
              '${widget.name}'
            ),
          ),
          body: FutureBuilder(
            future: _profileReq.getUserById(
              id: '${widget.userId}',
              pageKey: 1,
              pageSize: _pageSize
            ),
            builder: (context, snapshot) {

              if(snapshot.hasData) {

                // dynamic data = snapshot.data;
                // dynamic userInfo = data['data']['user'];
                // dynamic userPosts = data['posts']['posts'];

                return Container(
                color: Color(0xffF0F0F0),
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              AspectRatio(
                                aspectRatio: 5 / 2,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 120,
                                    maxHeight: 150,
                                    maxWidth: double.infinity
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(6), 
                                      topRight: Radius.circular(6)
                                    ),
                                    child:    
                                    userInfo['coverPic'] == 'default-cover-pic.png' ? Image.asset(
                                      'assets/images/cover-img-placeholder.jpg',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ) :                                  
                                    Image.network(
                                      '${userInfo['coverPic']}',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  ),
                                ),
                              ),
                              Positioned(
                                // top: 70,
                                bottom: -70,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0, top: 0),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 47,
                                          backgroundImage: 
                                          userInfo['profilePic'] == 'default-profile-pic.jpg' ? 
                                          AssetImage(
                                            'assets/images/profile-img-placeholder.jpg'
                                          ) as ImageProvider
                                          :
                                          NetworkImage(
                                            '${userInfo['profilePic']}'
                                          )
                                              
                                        ),
                                      ),
                                      SizedBox(height: 4.0,),
                                      if(widget.userId == animuzuId)
                                        Row(
                                          children: [
                                            Text(
                                              '${userInfo['name']}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 4.0,),
                                            Icon(
                                              Icons.check_circle_rounded,
                                              size: 18,
                                              color: ColorTheme.primary,
                                            )
                                          ],
                                        ),
                                      if(widget.userId != animuzuId)
                                        Text(
                                          '${userInfo['name']}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          //TODO: find some other way to make a margin here
                          SizedBox(height: 92.0,),
                          if(widget.userId == animuzuId) 
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                              child: Linkify(
                                onOpen: (link) async {
                                  if (await canLaunch(link.url)) {
                                    await launch(link.url);
                                  } else {
                                    throw 'Could not launch $link';
                                  }
                                },
                                text: userInfo['bio'] == null ? '' : userInfo['bio'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3
                                ),
                                linkStyle: TextStyle(
                                  color: Color(0xffffa500),//Colors.amber[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          if(widget.userId != animuzuId)
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                              child: Text(
                                userInfo['bio'] == null ? '' : userInfo['bio'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3
                                ),
                              ),
                            ),
                        ],
                      ),  
                      SizedBox(height: 16.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Artworks',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0,), 

                      PagedListView<int, dynamic>.separated(
                        pagingController: _pagingController,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        builderDelegate: PagedChildBuilderDelegate<dynamic>(
                          animateTransitions: true,
                          itemBuilder: (context, item, index) {

                            // dynamic reactedPosts = snapshot.data['data']['reacted'];

                            bool isReacted = false;

                            // print('bitch ${snapshot.data['data']['reacted']}');
                            print('reactedPostsProfile $reactedPosts');

                            for(int i = 0; i < reactedPosts.length; i++) {
                            
                              // print('reacted posts ${reactedPosts[i]['post']}');

                              if(reactedPosts[i]['post'] == item['_id']) {
                              
                                isReacted = true;

                                print('reacted shitProfile ${item['_id']}');

                              }

                            }

                            if(_pagingController.itemList == null) {

                              return Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Center(
                                  child: Text(
                                    "You have't add any post yet!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                    ),
                                  ) 
                                ),
                              );

                            }

                            return Post(
                              id: item['_id'],
                              name: userInfo['name'],
                              profilePic: '${userInfo['profilePic']}',
                              desc: item['description'],
                              postImg: item['postImages'], 
                              userId: item['user'],
                              date: item['createdAt'],
                              reactionCount: item['reactions'][0]['reactionCount'],
                              commentCount: item['commentCount'][0]['commentCount'],
                              // isUserPost: true,
                              isReacted: isReacted,
                              // reactedPosts: []
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

                      // ListView.builder(
                      //   itemCount: userPosts.length,
                      //   physics: NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   itemBuilder: (context, index) {
                
                
                      //     return Post(
                      //       id: userPosts[index]['_id'],
                      //       name: userInfo['name'],
                      //       profilePic: '${userInfo['profilePic']}',
                      //       desc: userPosts[index]['description'],
                      //       postImg: userPosts[index]['postImages'], //[ '${userPosts[index]['postImages'][0]}' ],
                      //       userId: 'user123',
                      //       date: userPosts[index]['createdAt'],
                      //       reactionCount: userPosts[index]['reactions'][0]['reactionCount'],
                      //       commentCount: userPosts[index]['commentCount'][0]['commentCount'],
                      //       isUserPost: true
                      //     );
                
                      //   }
                      // )
                    ],
                  )
                
                ),
              );

              }

              return Center(
                child: LoadingAnimation()
              );

            }
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}