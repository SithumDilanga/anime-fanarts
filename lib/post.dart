import 'dart:ui';

import 'package:anime_fanarts/comment_section.dart';
import 'package:anime_fanarts/img_fullscreen.dart';
import 'package:anime_fanarts/models/new_post_refresher.dart';
import 'package:anime_fanarts/models/reaction.dart';
import 'package:anime_fanarts/profile/users_profile.dart';
import 'package:anime_fanarts/report/select_reason.dart';
import 'package:anime_fanarts/services/download_share.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/services/interactions.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/date_time_formatter.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:gritie_new_app/utils/loading_animation.dart';
// import 'package:gritie_new_app/utils/route_trans_anim.dart';
// import 'package:gritie_new_app/services/shared_pref.dart';
// // import 'package:gritie_new_app/gritie_features/user_profile.dart';
// import 'package:gritie_new_app/services/database.dart';
// import 'package:gritie_new_app/utils/initialLetters.dart';
import 'package:readmore/readmore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animations/animations.dart';
import 'package:url_launcher/url_launcher.dart';

class Post extends StatefulWidget {

  final String? id;
  final String? name;
  final String? profilePic;
  final String? desc;
  final List? postImg;
  final String? userId;
  final String? date;
  final int? reactionCount;
  final int? commentCount;
  final bool isUserPost;
  bool isReacted;

   Post({ Key? key, this.id, this.name, this.profilePic, this.desc = '', this.postImg, this.userId, this.date, this.reactionCount, this.isUserPost = false, this.commentCount, this.isReacted = false}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {

  // bool isReacted = false;

  GetCreatePosts _getCreatePosts = GetCreatePosts();

  static const primaryColor = Color(0xffffa500); 
  // static const IMGURL = 'http://10.0.2.2:3000/img/users/';
  static const IMGURL = Urls.IMGURL;
  int imageIndex = 0;
  String userReaction = 'default';
  String? secureStorageUserId = '';

  Interactions _interactionsReq = Interactions();
  DateTimeFormatter _dateTimeFormatter = DateTimeFormatter();
  DownloadShare _downloadShare = DownloadShare();

  List imageList = ['https://images.alphacoders.com/120/thumb-1920-1203420.png', 'https://i.pinimg.com/originals/44/c3/21/44c321cf6862f22caf3e6b71a0661565.jpg','https://www.nawpic.com/media/2020/levi-ackerman-nawpic-17.jpg' ];

  String? firstHalf;
  String? secondHalf;

  bool flag = true;
  List<String> splittedDescText = [];  

  // update name Alert Dialog
  Future<void> _deletPostAlert(BuildContext context) async {

    var isNewPostAdded = Provider.of<NewPostFresher>(context, listen: false);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          title: const Text('Are you sure want to delete this ?'),
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
                'OK',
                style: TextStyle(
                  color: ColorTheme.primary,
                  fontSize: 18.0
                ),
              ),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.blue[50]),
              ),
              onPressed: () {

                _getCreatePosts.deletePost(widget.id).whenComplete(() {

                  Navigator.pop(context);

                  isNewPostAdded.updateIsPostDeleted(true);

                });

                // DatabaseService(uid: user.uid).updateUserName(
                //   name: _changeName.text
                // ).onError((error, stackTrace) {

                //   Fluttertoast.showToast(
                //     msg: "Error Occured : $error",
                //     toastLength: Toast.LENGTH_LONG,
                //     gravity: ToastGravity.BOTTOM,
                //     fontSize: 16.0
                //   );

                // }).whenComplete(() {

                //   Fluttertoast.showToast(
                //     msg: "Your public name changed to ${_changeName.text}",
                //     toastLength: Toast.LENGTH_LONG,
                //     gravity: ToastGravity.BOTTOM,
                //     fontSize: 16.0
                //   );

                //   Navigator.of(context).pop();

                //   setState(() {
                    
                //   });

                // });

              },  
            ),
          ],
        );
      },
    );
  }

  Future init() async {

    secureStorageUserId = (await SecureStorage.getUserId())!;
    
    if(this.mounted) {
      setState(() { });
    }

  }

  @override
  void initState() {
    super.initState();
    init();

    if(widget.desc != null) {

      if(widget.desc!.contains('adminFeature@')) {
        splittedDescText = widget.desc!.split('adminFeature@');
        print('splittedDescText ${splittedDescText[1]}');

        if (splittedDescText[0].length > 150) {
          firstHalf = splittedDescText[0].substring(0, 150);
          secondHalf = splittedDescText[0].substring(150, splittedDescText[0].length);
        } else {
          firstHalf = splittedDescText[0];
          secondHalf = "";
        }

      } else {

        if (widget.desc!.length > 150) {
          firstHalf = widget.desc!.substring(0, 150);
          secondHalf = widget.desc!.substring(150, widget.desc!.length);
        } else {
          firstHalf = widget.desc;
          secondHalf = "";
        }

      }

    }

  }

  @override
  Widget build(BuildContext context) {

    String userName = widget.name.toString();
    print('userName ' + userName);

    print('postImg ' + '$IMGURL${widget.postImg![0]}');
    print('images ' + '${widget.postImg![0]}');

    String formattedDate = _dateTimeFormatter.getFormattedDateFromFormattedString(
      value: widget.date, 
      currentFormat: "yyyy-MM-ddTHH:mm:ssZ", 
      desiredFormat: "yyyy-MM-dd hh:mm a"
    );

    print('widget.isReacted ${widget.isReacted}');

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4.0,
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if(widget.isUserPost)
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blueGrey[700],
                            backgroundImage: NetworkImage(
                              '${widget.profilePic}'
                            ),
                          ),
                        if(!widget.isUserPost)
                          GestureDetector(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                '${widget.profilePic}'
                              ),
                            ),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => UserProfile()),
                              // );
                              Navigator.of(context).push(
                                RouteTransAnim().createRoute(1.0, .0, UsersProfile(name: widget.name, userId: widget.userId,))
                              );
                            },
                          ),
                        SizedBox(width: 8.0,),

                        if(widget.userId == '621283374da8dc7d72b975bd')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(widget.isUserPost)
                                Text(
                                  widget.name!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0
                                  ),
                                ),
                              if(!widget.isUserPost)
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Text(
                                        '${widget.name!}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0
                                        ),
                                      ),
                                      SizedBox(width: 4.0,),
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: 16,
                                        color: ColorTheme.primary,
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                  
                                    Navigator.of(context).push(
                                      RouteTransAnim().createRoute(1.0, .0, UsersProfile(name: widget.name, userId: widget.userId))
                                    );

                                  },
                              ),
                              Text(
                                '$formattedDate',//widget.date.toString(),
                                style: TextStyle(
                                  fontSize: 11.0
                                ),
                              )
                            ],
                          ),
                        if(widget.userId != '621283374da8dc7d72b975bd')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              if(widget.isUserPost)
                                Text(
                                  widget.name!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0
                                  ),
                                ),
                              if(!widget.isUserPost)
                                GestureDetector(
                                  child: Text(
                                    widget.name!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0
                                    ),
                                  ),
                                  onTap: () {
                                  
                                    Navigator.of(context).push(
                                      RouteTransAnim().createRoute(1.0, .0, UsersProfile(name: widget.name, userId: widget.userId))
                                    );

                                  },
                                ),
                              Text(
                                '$formattedDate',//widget.date.toString(),
                                style: TextStyle(
                                  fontSize: 11.0
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                  if(widget.isUserPost && secureStorageUserId.toString() == widget.userId.toString())
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: ColorTheme.primary,
                      ),
                      onPressed: () {

                        _deletPostAlert(context);

                      }, 
                    ),
                  if(!widget.isUserPost)
                  PopupMenuButton(
                    color: Colors.grey[200],
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: ColorTheme.primary,
                    ),
                    onSelected: (selection) async {
                    
                      if(selection == 0) {
                      
                        Navigator.of(context).push(
                          RouteTransAnim().createRoute(
                            1.0, 0.0, 
                            SelectReason(postId: widget.id)
                          )
                        );

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
                              'Report this art',
                            ),
                          ],
                        ),
                        value: 0
                      ),
                      // PopupMenuItem(
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         Icons.share,
                      //         color: Colors.black,
                      //       ),
                      //       SizedBox(width: 8.0,),
                      //       Text(
                      //         'Share',
                      //       ),
                      //     ],
                      //   ),
                      //   value: 1
                      // ),
                      // PopupMenuItem(
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         Icons.download_rounded,
                      //         color: Colors.black,
                      //       ),
                      //       SizedBox(width: 8.0,),
                      //       Text(
                      //         'Save',
                      //       ),
                      //     ],
                      //   ),
                      //   value: 2
                      // ),
                    ]
                    )
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.more_horiz_rounded,
                    //     color: Colors.amber[600],
                    //   ),
                    //   onPressed: () { 
                    //   }, 
                    // )
                ],
              ),
              if(widget.desc!.isNotEmpty && widget.userId == '621283374da8dc7d72b975bd')

                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                  child: Container(
                    child: secondHalf!.isEmpty ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$firstHalf',
                          style: TextStyle(
                            fontSize: 16.0
                          ),
                        ),
                        SizedBox(height: 2.0,),
                        if(splittedDescText.isNotEmpty)
                          GestureDetector(
                            child: Text(
                              '${splittedDescText[1]}',
                              style: TextStyle(
                                color: ColorTheme.primary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                RouteTransAnim().createRoute(
                                  1.0, 0.0, 
                                  UsersProfile(
                                    name: splittedDescText[1],
                                    userId: splittedDescText[2],
                                  )
                                )
                              );
                            },
                          ),
                      ],
                    ) : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(flag ? (firstHalf! + "...") : (firstHalf! + secondHalf!)),
                        Linkify(
                          onOpen: (link) async {
                            if (await canLaunch(link.url)) {
                              await launch(link.url);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                          text: flag ? (firstHalf! + "...") : (firstHalf! + secondHalf!),
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.3
                          ),
                          linkStyle: TextStyle(
                            color: ColorTheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        if(splittedDescText.isNotEmpty)
                          GestureDetector(
                            child: Text(
                              '${splittedDescText[1]}',
                              style: TextStyle(
                                color: ColorTheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                RouteTransAnim().createRoute(
                                  1.0, 0.0, 
                                  UsersProfile(
                                    name: splittedDescText[1],
                                    userId: splittedDescText[2],
                                  )
                                )
                              );
                            },
                          ),
                        SizedBox(height: 2.0,),
                        GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                flag ? "show more" : "show less",
                                style: TextStyle(color: ColorTheme.primary),
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              flag = !flag;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  
                ),

              if(widget.desc!.isNotEmpty && widget.userId != '621283374da8dc7d72b975bd')
              
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                  child: Container(
                    child: secondHalf!.isEmpty ? Text(
                      '$firstHalf',
                      style: TextStyle(
                        fontSize: 16.0
                      ),
                    ) : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flag ? (firstHalf! + "...") : (firstHalf! + secondHalf!),
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                flag ? "show more" : "show less",
                                style: TextStyle(color: ColorTheme.primary),
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              flag = !flag;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  
                ),
              if(widget.postImg!.isNotEmpty)

                CarouselSlider.builder(
                  itemCount: widget.postImg!.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {

                    return GestureDetector(
                      child: Hero(
                        tag: '${widget.isUserPost.toString() + widget.postImg![itemIndex].toString()}',
                        child: Stack(
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 70,
                                minHeight: 70,
                                maxWidth: double.infinity,
                                maxHeight: 390,
                              ),
                              child: CachedNetworkImage(
                                // imageUrl: imageList[itemIndex].toString(),
                                imageUrl: '$IMGURL${widget.postImg![itemIndex]}',
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => imagePlaceholder(),
                              ),
                              // child: OpenContainer(
                              //   openColor: Colors.pink,
                              //   transitionType: ContainerTransitionType.fade,
                              //   closedBuilder: (BuildContext _, VoidCallback openContainer){
                              //     return CachedNetworkImage(
                              //       // imageUrl: imageList[itemIndex].toString(),
                              //       imageUrl: '$IMGURL${widget.postImg![itemIndex]}',
                              //       width: double.infinity,
                              //       fit: BoxFit.cover,
                              //       placeholder: (context, url) => imagePlaceholder(),
                              //     );
                              //   },
                              //   openBuilder: (BuildContext _, VoidCallback openContainer){
                              //     return ImgFullScreen(
                              //       imageList: widget.postImg, 
                              //       selectedimageIndex: itemIndex, 
                              //       imgLink: widget.postImg![itemIndex],
                              //     );
                              //   }
                              //   // child: CachedNetworkImage(
                              //   //   imageUrl: imageList[itemIndex].toString(),
                              //   //   width: double.infinity,
                              //   //   fit: BoxFit.cover,
                              //   //   placeholder: (context, url) => imagePlaceholder(),
                              //   // ),
                              // ),
                            ),
                            Positioned.fill(
                              top: 5,
                              left: 5,
                              child: ListView.builder(
                                itemCount: widget.postImg!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                              
                                  if(index == itemIndex) {
                              
                                    // return Icon(
                                    //   Icons.circle,
                                    //   color: Colors.blueAccent,
                                    // );
                                    return Stack(
                                      children: [
                                        Text(
                                          '${index + 1}/${widget.postImg!.length}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 0.8
                                            ..color = Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '${index + 1}/${widget.postImg!.length}',
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(0.5),
                                            fontSize: 11
                                          ),
                                        ),
                                      ],
                                    );
                              
                                  }
                                          
                                  return Text(
                                    ''
                                  );
                              
                                  // return Icon(
                                  //   Icons.circle
                                  // );
                                }, 
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                    
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) { 
                            return ImgFullScreen(
                              imageList: widget.postImg, 
                              selectedimageIndex: itemIndex, 
                              imgLink: widget.postImg![itemIndex],
                              isUserPost: widget.isUserPost
                            );
                          }),
                        );
                    
                      },
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: false,
                    viewportFraction: 1,
                    enableInfiniteScroll: false, 
                    // aspectRatio: 2.0,
                    // enlargeCenterPage: true,
                  ),
                ),

                // GestureDetector(
                //   child: ConstrainedBox(
                //     constraints: const BoxConstraints(
                //       minWidth: 70,
                //       minHeight: 70,
                //       maxWidth: double.infinity,
                //       maxHeight: 390,
                //     ),
                //     child: Container(
                //       child: CachedNetworkImage(
                //         imageUrl: widget.postImg!,
                //         width: double.infinity,
                //         fit: BoxFit.cover,
                //         placeholder: (context, url) => imagePlaceholder(),
                //       ),
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => ImgFullScreen(imgLink: widget.postImg,)),
                //     );
                //   },
                // ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                            SizedBox(width: 4.0,),
                            Text(
                              'comments ${widget.commentCount}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.white,
                          minimumSize: Size(50, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          side: BorderSide(
                            color: Colors.black,
                            width: 1
                          )
                        ),
                        onPressed: () {

                          Navigator.of(context).push(
                            RouteTransAnim().createRoute(
                              0.0, 1.0, 
                              CommentSecion(postId: widget.id, userId: widget.userId,)
                            )
                          );

                        },
                      ),
                      Row(
                        children: [
                          if(userReaction == 'default')
                            Text(
                              '${widget.reactionCount}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0
                              ),
                            ),
                          if(userReaction != 'default')
                            Text(
                              '${userReaction == 'add' ? widget.reactionCount! + 1 : 
                              widget.reactionCount}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0
                              ),
                            ),
                          widget.isReacted ? 
                          IconButton(
                            icon: Icon(
                              Icons.favorite_rounded,
                              color: ColorTheme.primary,
                            ),
                            onPressed: () {

                              _interactionsReq.createReaction(reaction: Reaction(
                                post: widget.id, 
                                reaction: 1
                              ));

                              setState(() {
                                widget.isReacted = !widget.isReacted;
                                userReaction = 'remove';
                              });

                            }, 
                          ) : 
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border_rounded,
                              color: Colors.black,
                            ),
                            onPressed: () {

                              _interactionsReq.createReaction(reaction: Reaction(
                                post: widget.id, 
                                reaction: 1
                              ));

                              setState(() {
                                widget.isReacted = !widget.isReacted;
                                userReaction = 'add';
                              });

                            }, 
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }

  Widget imagePlaceholder() {
    return Container(
      child: Image.asset(
        'assets/images/image placeholder 2.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
  
}