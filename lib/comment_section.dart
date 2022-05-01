import 'dart:io';
import 'package:anime_fanarts/profile/users_profile.dart';
import 'package:anime_fanarts/services/fcm.dart';
import 'package:anime_fanarts/services/interactions.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/date_time_formatter.dart';
import 'package:anime_fanarts/utils/error_loading.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CommentSecion extends StatefulWidget {

  final String? userId;
  final String? postId;

  const CommentSecion({ Key? key, required this.userId, required this.postId }) : super(key: key);

  @override
  _CommentSecionState createState() => _CommentSecionState();
}

class _CommentSecionState extends State<CommentSecion> {

  Interactions _interactionsReq = Interactions();
  DateTimeFormatter _dateTimeFormatter = DateTimeFormatter();

  final commentTextController = TextEditingController();

  static const _pageSize = 9;

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  final List<String> replyCommentsList = ['comment 1', 'comment 2', 'comment 3'];
  
  String commentReplyMention = '';

  final FocusNode _focusNode = FocusNode();

  final _firebaseCloudMessaging = FirebaseCloudMessaging();

  String? currentUserId = '';
  String? currentUserName = '';

  String replyingComment = '';
  int replyCommentIndex = 0;
  int subReplyCommentIndex = 0;
  String commentId = '';
  String replyCommentUserId = '';

  void init() async {
    currentUserId = await SecureStorage.getUserId();
    currentUserName = SharedPref.getUserName();
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    init();

    super.initState();
  }

  void _fetchPage(int pageKey) async {

    // print('pageKeyCommenr $pageKey');
    // print('_pageSizeComent $_pageSize');


    final allPostsData = await _interactionsReq.getComments(
      widget.postId,
      pageKey,
      _pageSize
    );

     try {
      final newItems = await allPostsData['data']['comments'];

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // int nextPageKey = (pageKey + newItems.length) as int;
        int nextPageKey = (pageKey + 1);
        _pagingController.appendPage(newItems, nextPageKey);
      }


    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    FocusScope.of(context).requestFocus(_focusNode);

    print('replyingComment $replyingComment');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
    
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0
            ),
            child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
          ),
          preferredSize: Size.fromHeight(0.0)
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorTheme.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
        title: Text(
          'Comments',
          style: TextStyle(
            color: ColorTheme.primary
          ),
        ),
        actions: [
          commentReplyMention.isNotEmpty ?
          Row(
            children: [
              Text(
                'replying',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    commentReplyMention = '';
                    replyingComment = '';
                  });
                }, 
              )
            ],
          ) : Text('')
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        color: Colors.blue[200],
        backgroundColor: ColorTheme.primary,
        child: Padding(
        padding: const EdgeInsets.only(
          left: 4.0, right: 4.0, top: 4.0
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        if(SharedPref.getProfilePic() == null)
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blueGrey[700],
                            backgroundImage: AssetImage(
                              'assets/images/profile-img-placeholder.jpg'
                            )
                            // NetworkImage(
                            //   'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
                            // ),
                          ),
                        if(SharedPref.getProfilePic() != null)
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blueGrey[700],
                          backgroundImage: FileImage(
                            File(SharedPref.getProfilePic()!)
                          ),
                          // NetworkImage(
                          //   'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
                          // ),
                        ),
                        SizedBox(width: 12.0,),
                        // Text(
                        //   'Levi Ackerman',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w500
                        //   ),
                        // )
                        Expanded(
                          child: Row(
                          children: [
                            Text(
                              '$commentReplyMention',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorTheme.primary
                              ),
                            ),
                            SizedBox(width: 4.0,),
                            Expanded(
                              child: RawKeyboardListener(
                                autofocus: true,
                                focusNode: FocusNode(),
                                onKey: (event) {
                                  print('event $event');

                                  if(event.logicalKey == LogicalKeyboardKey.keyQ) {
                                    print('backspace clicked');
                                  }

                                  if (event.isKeyPressed(LogicalKeyboardKey.keyQ)) {
                                    print('q key pressed'); // <--- works!
                                  }

                                  if(event.physicalKey == PhysicalKeyboardKey(0x0007002a)) {
                                    print('backspace clicked');
                                  }

                                },
                                child: TextFormField(
                                  controller: commentTextController,
                                  // initialValue: commentReplyMention.isNotEmpty ? commentReplyMention : null,
                                  cursorColor: ColorTheme.primary,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: ColorTheme.primary)
                                    ),
                                    // errorText: emailErrorText
                                    hintText: 'Leave a comment...'
                                  ),
                                  style: TextStyle(
                                    fontSize: 16
                                  ),
                                  // validation
                                  validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                                  onChanged: (val) {
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.send_rounded,
                                size: 28,
                                color: ColorTheme.primary,
                              ),
                              onPressed: () {
                  
                                // if(commentTextController.text.isNotEmpty && replyingComment.contains('main_comment_reply')) {

                                //   print('main comment');
                                //   print('replyingCommentInside $replyingComment');
                  
                                //   _interactionsReq.addNewComment(
                                //     commentTextController.text, 
                                //     widget.postId
                                //   );
                          
                                //   setState(() {
                                //     commentTextController.clear();
                                //     _pagingController.refresh();
                                //   });

                                //   // -------- for FCM -----------

                                //   // FirebaseCloudMessaging().sendCommentPushNotification(
                                //   //   userId: widget.userId,
                                //   //   postId: widget.postId
                                //   // );


                                //   // // TODO: fix logic for all occations
                                //   // if(replyingComment.contains('sub_comment')) {

                                //   //   print('sub_comment notification');

                                //   //   _firebaseCloudMessaging.sendCommentPushNotification(
                                //   //     userId: '625c2c4c4d883585a02d12c8',//item['user'][0]['_id'],
                                //   //     postId: widget.postId
                                //   //   );

                                //   // }

                                //   // -------- End for FCM -----------
                  
                                // } else 
                                if(commentTextController.text.isNotEmpty && replyingComment.contains('sub_comment') || replyingComment.contains('main_comment_reply')) {

                                  print('sub main comment');
                                  print('replyingCommentInside $replyingComment');

                                  if(commentId.isNotEmpty) {

                                    _interactionsReq.addNewReplyComment(
                                      commentTextController.text, 
                                      commentId,
                                      commentReplyMention
                                    ).whenComplete(() {

                                      setState(() {
                                        commentTextController.clear();
                                        _pagingController.refresh();
                                      });

                                    });

                                    print('replyCommentUserId $replyCommentUserId');

                                    if(replyCommentUserId == widget.userId) {

                                      FirebaseCloudMessaging().sendCommentPushNotification(
                                        userId: replyCommentUserId,
                                        postId: widget.postId,
                                        currentUserName: currentUserName,
                                        commentType: 'own_post_mention_comment'
                                      );

                                    } else if(widget.userId != currentUserId && commentReplyMention.isNotEmpty) {

                                      print('widget.userId != currentUserId');

                                      FirebaseCloudMessaging().sendCommentPushNotification(
                                        userId: widget.userId,
                                        postId: widget.postId,
                                        currentUserName: currentUserName,
                                        commentType: 'main_comment'
                                      );

                                    } else {

                                      print('mentioning');

                                      print('replyCommentUserId $replyCommentUserId');

                                      print('currentUserName $currentUserName');

                                      FirebaseCloudMessaging().sendCommentPushNotification(
                                        userId: replyCommentUserId,
                                        postId: widget.postId,
                                        currentUserName: currentUserName,
                                        commentType: 'mention_comment'
                                      );

                                    }


                                    // if there is a new reply comment post user also notifies TODO: check this logic works
                                    // if(widget.userId != currentUserId) {

                                    //   FirebaseCloudMessaging().sendCommentPushNotification(
                                    //     userId: widget.userId,
                                    //     postId: widget.postId,
                                    //     currentUserName: currentUserName,
                                    //     commentType: 'main_comment'
                                    //   );

                                    // }

                                  }
                                    
                                } else if(commentReplyMention.isEmpty) {

                                  print('adding main comment');

                                  _interactionsReq.addNewComment(
                                    commentTextController.text, 
                                    widget.postId,
                                  );

                                  FirebaseCloudMessaging().sendCommentPushNotification(
                                    userId: widget.userId,
                                    postId: widget.postId,
                                    currentUserName: currentUserName,
                                    commentType: 'main_comment'
                                  );
                          
                                  setState(() {
                                    commentTextController.clear();
                                    _pagingController.refresh();
                                  });

                                } else {

                                  Fluttertoast.showToast(
                                    msg: "comment text is empty",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 16.0
                                  );

                                }
                                                              
                              }, 
                            )
                          ],
                        ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: PagedListView<int, dynamic>.separated(
                  pagingController: _pagingController,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    animateTransitions: true,
                    itemBuilder: (context, item, index) {
                      
                      String formattedDate = _dateTimeFormatter.getFormattedDateFromFormattedString(
                        value: item['createdAt'].toString(), 
                        currentFormat: "yyyy-MM-ddTHH:mm:ssZ", 
                        desiredFormat: "yyyy-MM-dd hh:mm a"
                      );
                      
                      bool isReplying = false;
              
                      if(replyingComment == 'main_comment_reply' && replyCommentIndex == index) {
                        isReplying = true;
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: GestureDetector(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.blueGrey[700],
                                        backgroundImage: item['user'][0]['profilePic'] == 'default-profile-pic.jpg' ? AssetImage( //[0]
                                          'assets/images/profile-img-placeholder.jpg'
                                        ) as ImageProvider : NetworkImage(
                                          '${item['user'][0]['profilePic']}' 
                                        ),//[0]
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                            
                                    Navigator.of(context).push(
                                      RouteTransAnim().createRoute(1.0, .0, UsersProfile(
                                        name: '${item['user'][0]['name']}', //[0]
                                        userId: item['user'][0]['_id'], //[0]
                                      )),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),  
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 12.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        // mainAxisSize : MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            child: Row(
                                              children: [
                                                // CircleAvatar(
                                                //   radius: 18,
                                                //   backgroundColor: Colors.blueGrey[700],
                                                //   backgroundImage: item['user'][0]['profilePic'] == 'default-profile-pic.jpg' ? AssetImage(
                                                //     'assets/images/profile-img-placeholder.jpg'
                                                //   ) as ImageProvider : NetworkImage(
                                                //     '${item['user'][0]['profilePic']}'
                                                //   ),
                                                // ),
                                                SizedBox(width: 8.0,),
                                                Text(
                                                  '${item['user'][0]['name']}', //[0]
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500
                                                  ),
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                                      
                                              Navigator.of(context).push(
                                                RouteTransAnim().createRoute(1.0, .0, UsersProfile( //[0]
                                                  name: '${item['user'][0]['name']}', 
                                                  userId: item['user'][0]['_id'],
                                                )),
                                              );
                                                      
                                            },
                                          ),
                                          SizedBox(width: 8.0,),
                                          Flexible(
                                            child: Text(
                                              '$formattedDate',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8.0,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            '${item['comment']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 0.5,
                                              height: 1.2,
                                              fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                      ),                          
                                    ],
                                  ),
                                ),
                              ),
                              ),
                            ],
                          ),

                        // --------- reply comment feature ---------

                        SizedBox(height: 2.0,),
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.0, bottom: 8.0),
                            child: Text(
                              'Reply',
                              style: TextStyle(
                                color: isReplying == true ? ColorTheme.primary : Colors.black
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              commentReplyMention = item['user'][0]['name'];
                              replyingComment = 'main_comment_reply';
                              replyCommentIndex = index;
                              commentId = item['_id'];
                              replyCommentUserId = item['user'][0]['_id'];
                            });
              
                            // _firebaseCloudMessaging.sendCommentPushNotification(
                            //   userId: item['user'][0]['_id'],
                            //   postId: widget.postId
                            // );
              
                          },
                        ),

                        if(item['replyComments'].isNotEmpty)

                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            itemCount: item['replyComments'].length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, itemIndex) {
              
                              bool isSubReplying = false;
              
                              if(replyingComment == 'sub_comment${item['replyComments'][itemIndex]['user']['_id']}' && subReplyCommentIndex == itemIndex) {
              
                                isSubReplying = true;
              
                              }
              
                              return Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 28.0,),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: GestureDetector(
                                            child: CircleAvatar(
                                              radius: 14,
                                              backgroundColor: Colors.blueGrey[700],
                                              backgroundImage: item['replyComments'][itemIndex]['user']['profilePic'] == 'default-profile-pic.jpg' ? AssetImage(
                                                'assets/images/profile-img-placeholder.jpg'
                                              ) as ImageProvider : NetworkImage(
                                                '${item['replyComments'][itemIndex]['user']['profilePic']}'
                                              ),
                                            ),
                                            onTap: () {
              
                                              Navigator.of(context).push(
                                                RouteTransAnim().createRoute(1.0, .0, UsersProfile(
                                                  name: '${item['replyComments'][itemIndex]['user']['name']}', 
                                                  userId: item['replyComments'][itemIndex]['user']['_id'],
                                                )),
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),  
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 12.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  // mainAxisSize : MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 8.0,),
                                                          Text(
                                                            '${item['replyComments'][itemIndex]['user']['name']}',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      onTap: () {
                                                                
                                                        Navigator.of(context).push(
                                                          RouteTransAnim().createRoute(1.0, .0, UsersProfile(
                                                            name: '${item['replyComments'][itemIndex]['user']['name']}', 
                                                            userId: item['replyComments'][itemIndex]['user']['_id'],
                                                          )),
                                                        );
                                                                
                                                      },
                                                    ),
                                                    SizedBox(width: 8.0,),
                                                    Flexible(
                                                      child: Text(
                                                        '$formattedDate',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.normal
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 8.0,),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '${item['replyComments'][itemIndex]['replyMention']}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: ColorTheme.primary,
                                                            letterSpacing: 0.5,
                                                            height: 1.2,
                                                            fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                        SizedBox(width: 4.0,),
                                                        Text(
                                                          '${item['replyComments'][itemIndex]['comment']}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            letterSpacing: 0.5,
                                                            height: 1.2,
                                                            fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),                          
                                              ],
                                            ),
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.0,),
                                    Padding(
                                      padding: EdgeInsets.only(right: 16.0, bottom: 8.0),
                                      child: GestureDetector(
                                        child: Text(
                                          'Reply',
                                          style: TextStyle(
                                            color: isSubReplying == true ? ColorTheme.primary : Colors.black
                                          ),
                                        ),
                                        onTap: () {
              
                                          setState(() {
                                            // TODO: this should changed to reply comment name
                                            commentReplyMention = item['replyComments'][itemIndex]['user']['name'];

                                            replyingComment = 'sub_comment${item['replyComments'][itemIndex]['user']['_id']}';
                                            //replyingComment = 'sub_comment${item[itemIndex]['user']['_id']}';
                                            subReplyCommentIndex = itemIndex;
                                            commentId = item['_id'];

                                            replyCommentUserId = item['replyComments'][itemIndex]['user']['_id'];

                                          });

                                          // _firebaseCloudMessaging.sendCommentPushNotification(
                                          //   userId: '625c2b524d883585a02d123b',//item['user'][0]['_id'],
                                          //   postId: widget.postId
                                          // );
              
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )

                        // --------- End reply comment feature ---------
                        ],
                      );
                      
                    },
                    firstPageErrorIndicatorBuilder: (context) => ErrorLoading(
                      errorMsg: 'Error loading comments: code #003', 
                      onTryAgain: _pagingController.refresh
                    ) 
                    ,
                    noItemsFoundIndicatorBuilder: (context) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'No comments yet!',
                          style: TextStyle(
                            fontSize: 16.0
                          ),
                        ),
                      ),
                    ),
                    newPageErrorIndicatorBuilder: (context) => ErrorLoading(
                      errorMsg: 'Error loading comments: code #004', 
                      onTryAgain: _pagingController.refresh
                    ),
                    firstPageProgressIndicatorBuilder: (context) => LoadingAnimation(),
                    newPageProgressIndicatorBuilder: (context) => LoadingAnimation(),
                    noMoreItemsIndicatorBuilder: (context) => 
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          '...',
                          style: TextStyle(
                            fontSize: 16.0
                          ),
                        ),
                      ),
                    )
                  ),
                  separatorBuilder: (context, index) => const Divider(height: 0,),
                ),
              ),
            ),
            // Card(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(15.0),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Row(
            //           children: [
            //             if(SharedPref.getProfilePic() == null)
            //               CircleAvatar(
            //                 radius: 20,
            //                 backgroundColor: Colors.blueGrey[700],
            //                 backgroundImage: AssetImage(
            //                   'assets/images/profile-img-placeholder.jpg'
            //                 )
            //                 // NetworkImage(
            //                 //   'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
            //                 // ),
            //               ),
            //             if(SharedPref.getProfilePic() != null)
            //             CircleAvatar(
            //               radius: 20,
            //               backgroundColor: Colors.blueGrey[700],
            //               backgroundImage: FileImage(
            //                 File(SharedPref.getProfilePic()!)
            //               ),
            //               // NetworkImage(
            //               //   'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
            //               // ),
            //             ),
            //             SizedBox(width: 12.0,),
            //             // Text(
            //             //   'Levi Ackerman',
            //             //   style: TextStyle(
            //             //     fontSize: 16,
            //             //     fontWeight: FontWeight.w500
            //             //   ),
            //             // )
            //             Expanded(
            //               child: Row(
            //               children: [
            //                 Text(
            //                   '$commentReplyMention',
            //                   style: TextStyle(
            //                     fontSize: 16,
            //                     fontWeight: FontWeight.bold,
            //                     color: ColorTheme.primary
            //                   ),
            //                 ),
            //                 SizedBox(width: 4.0,),
            //                 Expanded(
            //                   child: RawKeyboardListener(
            //                     autofocus: true,
            //                     focusNode: FocusNode(),
            //                     onKey: (event) {
            //                       print('event $event');

            //                       if(event.logicalKey == LogicalKeyboardKey.keyQ) {
            //                         print('backspace clicked');
            //                       }

            //                       if (event.isKeyPressed(LogicalKeyboardKey.keyQ)) {
            //                         print('q key pressed'); // <--- works!
            //                       }

            //                       if(event.physicalKey == PhysicalKeyboardKey(0x0007002a)) {
            //                         print('backspace clicked');
            //                       }

            //                     },
            //                     child: TextFormField(
            //                       controller: commentTextController,
            //                       // initialValue: commentReplyMention.isNotEmpty ? commentReplyMention : null,
            //                       cursorColor: ColorTheme.primary,
            //                       maxLines: null,
            //                       keyboardType: TextInputType.multiline,
            //                       decoration: InputDecoration(
            //                         focusedBorder: UnderlineInputBorder(
            //                           borderSide: BorderSide(color: ColorTheme.primary)
            //                         ),
            //                         // errorText: emailErrorText
            //                         hintText: 'Leave a comment...'
            //                       ),
            //                       style: TextStyle(
            //                         fontSize: 16
            //                       ),
            //                       // validation
            //                       validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
            //                       onChanged: (val) {
            //                       },
            //                     ),
            //                   ),
            //                 ),
            //                 IconButton(
            //                   icon: Icon(
            //                     Icons.send_rounded,
            //                     size: 28,
            //                     color: ColorTheme.primary,
            //                   ),
            //                   onPressed: () {
                  
            //                     if(commentTextController.text.isNotEmpty) {
                  
            //                       _interactionsReq.addNewComment(
            //                         commentTextController.text, 
            //                         widget.postId
            //                       );
                          
            //                       setState(() {
            //                         commentTextController.clear();
            //                         _pagingController.refresh();
            //                       });

            //                       FirebaseCloudMessaging().sendCommentPushNotification(
            //                         userId: widget.userId,
            //                         postId: widget.postId
            //                       );
                  
            //                     } else {
                  
            //                       Fluttertoast.showToast(
            //                         msg: "comment text is empty",
            //                         toastLength: Toast.LENGTH_SHORT,
            //                         gravity: ToastGravity.BOTTOM,
            //                         fontSize: 16.0
            //                       );
                  
            //                     }
                                                              
            //                   }, 
            //                 )
            //               ],
            //                                       ),
            //             ),
            //           ],
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(left: 20.0),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
                ),
      )
    
      );
  }
}