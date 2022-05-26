import 'package:anime_fanarts/main.dart';
import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/profile/followers_list.dart';
import 'package:anime_fanarts/report/reasons_user_report.dart';
import 'package:anime_fanarts/services/block_user_req.dart';
import 'package:anime_fanarts/services/profile_req.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/error_loading.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anime_fanarts/utils/custom_icons.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class UsersProfileTest extends StatefulWidget {

  final String? name;
  final String? userId;

  const UsersProfileTest({ Key? key, required this.name, required this.userId, }) : super(key: key);

  @override
  UsersProfileTestState createState() => UsersProfileTestState();
}

class UsersProfileTestState extends State<UsersProfileTest> with AutomaticKeepAliveClientMixin<UsersProfileTest> {

  // ------- 🏃 following logic 🏃 ----------

    // isFollowDefaultMode = false and int followUserActionState != 1 : started following a new user

    // isFollowDefaultMode = false and int followUserActionState = 1 : started unfollowing the just followed new user

    // isFollowDefaultMode = true and int followUserActionState != 1 : started unfollowing the already followed user

    // isFollowDefaultMode = true and int followUserActionState = 1 : started following the just followed new user but already followed before

  // ------- End 🏃 following logic 🏃 ----------

  static const animuzuId = Urls.animuzuUserId;

  String? currentUserId;

  int followUserActionState = 0;

  static const _pageSize = 8;
  List reactedPosts = [];
  bool isFollow = false;
  bool isFollowDefaultMode = false;
  dynamic userInfo = {
     "profilePic": "default-profile-pic.jpg",
     "coverPic": "default-cover-pic.png",
     "name": "Loading...",
   };

  final PagingController<int, dynamic> _pagingController = PagingController(firstPageKey: 1);

  ProfileReq _profileReq = ProfileReq();
  BlockUserReq _blockUserReq = BlockUserReq();


   void _fetchPage(int pageKey) async {

     final allPostsData = await _profileReq.getUserById(
       id: '${widget.userId}',
       pageKey: pageKey,
       pageSize: _pageSize
     );

     try {  

      final newItems = await allPostsData['posts']['posts'];

      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // int nextPageKey = (pageKey + newItems.length) as int;
        int nextPageKey = (pageKey + 1);
        _pagingController.appendPage(newItems, nextPageKey);
      }

      setState(() {
        reactedPosts = reactedPosts + allPostsData['reacted'];
        userInfo = allPostsData['data']['user'];

        if(allPostsData['followed'] != null) {
          isFollow = allPostsData['followed'];
          isFollowDefaultMode = allPostsData['followed'];
        }

      });

    } catch (error) {
      _pagingController.error = error;
    }
  }

  // block user confirmation Alert Dialog
  Future<void> _blockUserConfirmAlert(BuildContext context, String? userId, String? name) async {

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Are you sure you want to block this user ? You won't see any artworks from this user if you block."),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: ColorTheme.primary,
                      fontSize: 18.0
                    ),
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.blue[50]),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                ),
                TextButton(
                  child: Text(
                    'YES',
                    style: TextStyle(
                      color: ColorTheme.primary,
                      fontSize: 18.0
                    ),
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.blue[50]),
                  ),
                  onPressed: () {

                    SharedPref.setBlockedUserIdsList(
                     blockedUserId: userId!,
                    ).then((value) {

                      SharedPref.setBlockedUserNamesList(name!).whenComplete(() {

                        _blockUserReq.sendBlockedUser(
                          widget.userId,
                          widget.name
                        );

                        print('blockedUserIds ${SharedPref.getBlockedUserIdsList()}');
                        print('blockedUserNames ${SharedPref.getBlockedUserNamesList()}');
                        
                        Navigator.of(context).pushAndRemoveUntil(
                         MaterialPageRoute(
                             builder: (context) => MyApp(selectedPage: 0)),
                             (route) => false
                        );

                      });

                    });

                  },  
                ),
              ],
            );
          }
        );
      },
    );
  }

  init() async {

    currentUserId = await SecureStorage.getUserId() ?? '';

    print('currentUserId $currentUserId');

  }

  @override
  void initState() {

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    init();

    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

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
              '${widget.name}',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
            actions: [
              PopupMenuButton(
                color: Colors.grey[200],
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ),
                onSelected: (selection) async {
                
                  if(selection == 0) {
                  
                    Navigator.of(context).push(
                      RouteTransAnim().createRoute(
                        1.0, 0.0, 
                        SelectUserReportReason(
                          userId: widget.userId,
                        )
                      )
                    );
                  } else if(selection == 1) {

                    _blockUserConfirmAlert(context, widget.userId, widget.name);

                  } 
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          Icons.report_gmailerrorred_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8.0,),
                        Text(
                          'Report inappropriate user',
                        ),
                      ],
                    ),
                    value: 0
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          Icons.block_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8.0,),
                        Text(
                          'Block this user',
                        ),
                      ],
                    ),
                    value: 1
                  ),
                ]
              )
            ],
          ),
          body: FutureBuilder(
            future: _profileReq.getUserById(
              id: '${widget.userId}',
              pageKey: 1,
              pageSize: _pageSize
            ),
            builder: (context, snapshot) {

              if(snapshot.hasData) {

                // ---- had to come up with logic in order fix the innapropriate space issue when there's no social platform added by the user -----

                String checkSocialPlatforms = '';

                if(userInfo['socialPlatforms'] != null) {
                  for(int i = 0; i < userInfo['socialPlatforms'].length; i++) {
                    checkSocialPlatforms = checkSocialPlatforms + userInfo['socialPlatforms'][i]['link'];
                  }
                }

                // --- End the logic ----

                Map<String, IconData> iconsMap = {
                 'twitter': CustomIcons.twitter,
                 'insta': CustomIcons.insta,
                 'pinterest': CustomIcons.pinterest,
                 'deviantArt': CustomIcons.deviantArt,
                 'artstation': CustomIcons.artstation,
                 'tiktok': CustomIcons.tiktok,
                 'website': CustomIcons.website,
                };

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
                                bottom: -40,
                                left: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    // SizedBox(height: 4.0,),
                                    // if(widget.userId == animuzuId)
                                    //   Row(
                                    //     children: [
                                    //       Text(
                                    //         '${userInfo['name']}',
                                    //         style: TextStyle(
                                    //           fontSize: 18,
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 4.0,),
                                    //       Icon(
                                    //         Icons.check_circle_rounded,
                                    //         size: 18,
                                    //         color: ColorTheme.primary,
                                    //       )
                                    //     ],
                                    //   ),
                                    // if(widget.userId != animuzuId)
                                    //   Text(
                                    //     '${userInfo['name']}',
                                    //     style: TextStyle(
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    // Text(
                                    //   '@username'
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: Text(
                                        isFollow ? 'Following' : 'Follow',
                                        style: TextStyle(
                                          color: isFollow ? Colors.white : ColorTheme.primary
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                        width: 1.5, 
                                        color: ColorTheme.primary,
                                      ),
                                      primary: isFollow ? ColorTheme.primary : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      // elevation: 4.0,
                                    ),
                                    onPressed: currentUserId != userInfo['_id'] ? () {

                                      setState(() {
                                        isFollow = !isFollow;
                                        
                                        followUserActionState++;

                                        if(followUserActionState == 3) {
                                          followUserActionState = 1;
                                        }

                                      });

                                      _profileReq.addNewfollowUpUser(
                                        userId: widget.userId
                                      );

                                    } : null, 
                                  ),
                                  // Text(
                                  //   '536 Followers'
                                  // )
                                ],
                              ),
                            ),
                          ),
                          //TODO: find some other way to make a margin here
                          SizedBox(height: 4.0,),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                              child: Column(
                                children: [
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${userInfo['name']}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // default mode
                                            if(userInfo['followers'] != null && !isFollowDefaultMode && followUserActionState != 1 )
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  text: '${userInfo['followers'][0]['followersCount']} ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'Followers', 
                                                      style: TextStyle(
                                                        color: ColorTheme.primary,
                                                        fontWeight: FontWeight.normal
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // when user started following
                                            if(userInfo['followers'] != null && !isFollowDefaultMode && followUserActionState == 1)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  text: '${userInfo['followers'][0]['followersCount'] + 1} ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'Followers', 
                                                      style: TextStyle(
                                                        color: ColorTheme.primary,
                                                        fontWeight: FontWeight.normal
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // user started unfollowing when he already followed
                                            if(userInfo['followers'] != null && isFollowDefaultMode && followUserActionState != 1)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  text: '${userInfo['followers'][0]['followersCount']} ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'Followers', 
                                                      style: TextStyle(
                                                        color: ColorTheme.primary,
                                                        fontWeight: FontWeight.normal
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            
                                            // user started following when he already followed and unfollowed
                                            if(userInfo['followers'] != null && isFollowDefaultMode && followUserActionState == 1)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  text: '${userInfo['followers'][0]['followersCount'] - 1} ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'Followers', 
                                                      style: TextStyle(
                                                        color: ColorTheme.primary,
                                                        fontWeight: FontWeight.normal
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '@username'
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0,),
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // if(userInfo['followers'] != null)
                                    // GestureDetector(
                                    //   child: RichText(
                                    //     text: TextSpan(
                                    //       text: '${userInfo['followers'][0]['followersCount']} ',
                                    //       style: TextStyle(
                                    //         color: Colors.black,
                                    //         fontWeight: FontWeight.bold
                                    //       ),
                                    //       children: <TextSpan>[
                                    //         TextSpan(
                                    //           text: 'Followers', 
                                    //           style: TextStyle(
                                    //             color: ColorTheme.primary,
                                    //             fontWeight: FontWeight.normal
                                    //           )
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //   onTap: () {
                                    //     Navigator.of(context).push(
                                    //       RouteTransAnim().createRoute(
                                    //         1.0, 0.0, 
                                    //         FollowersList()
                                    //       )
                                    //     );
                    
                                    //   }
                                    // ),
                                    // SizedBox(height: 12.0,),
                                    Text(
                                      userInfo['bio'] == null ? '' : userInfo['bio'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 1.3
                                      ),
                                    ),
                                    SizedBox(height: 8.0,),

                                    // check whether user added at least one social platform
                                    if(checkSocialPlatforms.isNotEmpty)
                                    Material(
                                      color: Colors.transparent,
                                      child: GridView.count(
                                        shrinkWrap: true,
                                        primary: false,
                                        // padding: const EdgeInsets.all(20),
                                        // crossAxisSpacing: 10,
                                        // mainAxisSpacing: 10,
                                        crossAxisCount: 8,
                                        children: [
                                          if(userInfo['socialPlatforms'] != null)
                                          for(int i = 0; i < userInfo['socialPlatforms'].length; i++)
                                            if(userInfo['socialPlatforms'][i]['link'].isNotEmpty)
                                            Row(
                                              children: [
                                                InkWell(
                                                  splashColor: Colors.grey,
                                                  customBorder: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Icon(
                                                      iconsMap['${userInfo['socialPlatforms'][i]['socialPlatform']}'],
                                                      color: ColorTheme.primary,
                                                      size: userInfo['socialPlatforms'][i]['socialPlatform'] == 'website' ? 18 : null
                                                    ),
                                                  ),
                                                  onTap: () async {

                                                    String url = '${userInfo['socialPlatforms'][i]['link']}';

                                                    try {

                                                      if(await canLaunch(url)){
                                                        await launch(
                                                          url, 
                                                          // forceWebView: true,
                                                          enableJavaScript: true
                                                        ); 
                                                      } else {
                                                        throw 'Could not launch $url';
                                                      }

                                                    } catch(e) {

                                                      throw(e);

                                                    }

                                                  },
                                                ),
                                              ],
                                            )
                                        ],
                                      )
                                    ),
                                    SizedBox(height: 8.0,),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),  
                      SizedBox(height: 4.0,),
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


                            for(int i = 0; i < reactedPosts.length; i++) {
                            

                              if(reactedPosts[i]['post'] == item['_id']) {
                              
                                isReacted = true;


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