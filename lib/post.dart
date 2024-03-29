import 'dart:async';
import 'package:anime_fanarts/comment_section.dart';
import 'package:anime_fanarts/img_fullscreen.dart';
import 'package:anime_fanarts/main.dart';
import 'package:anime_fanarts/models/reacted_posts.dart';
import 'package:anime_fanarts/models/reaction.dart';
import 'package:anime_fanarts/profile/reacted_users_list.dart';
import 'package:anime_fanarts/profile/users_profile.dart';
import 'package:anime_fanarts/profile/users_profile_test.dart';
import 'package:anime_fanarts/report/select_reason.dart';
import 'package:anime_fanarts/services/download_share.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/services/interactions.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/date_time_formatter.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:extended_image/extended_image.dart';
// import 'package:transparent_image/transparent_image.dart';
import 'dart:ui' as ui;


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
  // final List reactedPosts;

    // required this.reactedPosts
   Post({ Key? key, this.id, this.name, this.profilePic, this.desc = '', this.postImg, this.userId, this.date, this.reactionCount, this.isUserPost = false, this.commentCount, this.isReacted = false }) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> with AutomaticKeepAliveClientMixin<Post> {

  // bool isReacted = false;

  GetCreatePosts _getCreatePosts = GetCreatePosts();
  static const animuzuId = Urls.animuzuUserId;

  static const primaryColor = Color(0xffffa500); 
  String userReaction = 'default';
  String? secureStorageUserId = '';

  // static bool isReacted = false;

  Interactions _interactionsReq = Interactions();
  DateTimeFormatter _dateTimeFormatter = DateTimeFormatter();
  DownloadShare _downloadShare = DownloadShare();

  String? firstHalf;
  String? secondHalf;

  bool flag = true;
  List<String> splittedDescText = [];  

  // update name Alert Dialog
  Future<void> _deletPostAlert(BuildContext context) async {


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

                  // isNewPostAdded.updateIsPostDeleted(true);
                  Navigator.pop(context);

                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyApp(selectedPage: 1)
                    )
                  );

                });

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

    // setState(() {
    //   isReacted = widget.isReacted;
    // });

    if(widget.desc != null) {

      if(widget.desc!.contains('adminFeature@')) {
        splittedDescText = widget.desc!.split('adminFeature@');

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
    super.build(context);

    String formattedDate = _dateTimeFormatter.getFormattedDateFromFormattedString(
      value: widget.date, 
      currentFormat: "yyyy-MM-ddTHH:mm:ssZ", 
      desiredFormat: "yyyy-MM-dd hh:mm a"
    );

    final reactedPosts = Provider.of<ReactedPosts>(context);

     Image _aspectRatioImage = new Image.network('${widget.postImg![0]}');
     Completer<ui.Image> completer = new Completer<ui.Image>();

     _aspectRatioImage.image
       .resolve(new ImageConfiguration())
       .addListener(new ImageStreamListener((ImageInfo image, bool _) {
       completer.complete(image.image);
     }));

     double appbarHeight = AppBar().preferredSize.height;
     double tabbarHeight = TabBar(tabs: [],).preferredSize.height;

     double screenHeight = MediaQuery.of(context).size.height - (appbarHeight + tabbarHeight + 50);
     double screenWidth = MediaQuery.of(context).size.width;

    // ---------- splite height and width from the img url -----------

    String heightWidth = widget.postImg![0].toString().substring(131).split(".").first;

    double height = double.parse(heightWidth.split("-").first);
    double width = double.parse(heightWidth.split("-").last);

    // ---------- End splite height and width from the img url -----------

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
            // crossAxisAlignment: CrossAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(widget.isUserPost)
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blueGrey[700],
                            backgroundImage: widget.profilePic == 'default-profile-pic.jpg' ? AssetImage(
                              'assets/images/profile-img-placeholder.jpg'
                            ) as ImageProvider : ExtendedNetworkImageProvider(
                                '${widget.profilePic}',
                                // cache: true,
                              ),
                            // NetworkImage(
                            //   '${widget.profilePic}',
                            // ),
                          ),
                        if(!widget.isUserPost)
                          GestureDetector(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: widget.profilePic == 'default-profile-pic.jpg' ? AssetImage(
                                'assets/images/profile-img-placeholder.jpg'
                              ) as ImageProvider : ExtendedNetworkImageProvider(
                                '${widget.profilePic}',
                                // cache: true,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                RouteTransAnim().createRoute(
                                  1.0, .0, 
                                  // UsersProfile(
                                  //   name: widget.name, 
                                  //   userId: widget.userId,
                                  // )
                                  UsersProfileTest(
                                    name: widget.name, 
                                    userId: widget.userId
                                  )
                                )
                              );
                            },
                          ),
                        SizedBox(width: 8.0,),

                        if(widget.userId == animuzuId)

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
                        if(widget.userId != animuzuId)
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                          
                                if(widget.isUserPost)
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width - 160 // this kind of a logic had to give for adjusting the name to a new line
                                    ),
                                    child: Text(
                                      widget.name!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0
                                      ),
                                    ),
                                  ),
                                if(!widget.isUserPost)
                                  GestureDetector(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width - 160 // this kind of a logic had to give for adjusting the name to a new line
                                      ),
                                      child: Text(
                                        widget.name!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                    
                                      Navigator.of(context).push(
                                        RouteTransAnim().createRoute(
                                          1.0, .0, 
                                          UsersProfile(name: widget.name, userId: widget.userId)
                                          // UsersProfileTest(
                                          //   name: widget.name, 
                                          //   userId: widget.userId
                                          // )
                                        )
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
                          ),
                      ],
                    ), 
                  ),
                  if(widget.isUserPost && secureStorageUserId.toString() == widget.userId.toString())
                    Flexible(
                      child: IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: ColorTheme.primary,
                        ),
                        onPressed: () {
                      
                          _deletPostAlert(context);
                      
                        }, 
                      ),
                    ),
                  if(!widget.isUserPost)
                  Flexible(
                    child: PopupMenuButton(
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
                      ]
                      ),
                  )
                ],
              ), 
              if(widget.desc!.isNotEmpty && widget.userId == animuzuId)

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
              if(widget.desc!.isNotEmpty && widget.userId != animuzuId)
              
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
                
                   // Completer<ui.Image> completer = new Completer<ui.Image>();
                
                   // ExtendedImage _image = new ExtendedImage.network(
                   //   '${widget.postImg![itemIndex]}',
                   //   // width: double.infinity,
                   //   // fit: BoxFit.fitHeight,
                   //   cache: true,
                   //   // cacheHeight: 500,
                   //   cacheWidth: 600,
                   //   loadStateChanged: (ExtendedImageState state) {
                   //     switch (state.extendedImageLoadState) {
                   //       case LoadState.loading:
                   //         return Image.asset(
                   //           "assets/images/image placeholder 2.jpg",
                   //           fit: BoxFit.cover,
                   //         );
                           
                   //         case LoadState.completed:
                   //           return null;
                   
                   //         case LoadState.failed:
                   //          return null;
                   //     }
                   //   },
                   // ); 
                
                   // _image.image
                   //   .resolve(new ImageConfiguration())
                   //   .addListener(new ImageStreamListener((ImageInfo image, bool _) {
                   //   completer.complete(image.image);
                   // }));
                       
                       return GestureDetector(
                         child: Hero(
                           tag: '${widget.isUserPost.toString() + widget.postImg![itemIndex].toString()}',
                           child: Stack(
                             fit: StackFit.expand,
                             children: [
                               FittedBox(
                                 fit: BoxFit.fitWidth,
                                 clipBehavior: Clip.hardEdge,
                                 child: //_image
                                 ExtendedImage.network(
                                   '${widget.postImg![itemIndex]}',
                                   // width: double.infinity,
                                   // fit: BoxFit.fitHeight,
                                   cache: true,
                                   // cacheHeight: 500,
                                   cacheWidth: 600,
                                   loadStateChanged: (ExtendedImageState state) {
                                     switch (state.extendedImageLoadState) {
                                       case LoadState.loading:
                                         return Image.asset(
                                           "assets/images/image placeholder 2.jpg",
                                           fit: BoxFit.cover,
                                         );
                                         
                                         case LoadState.completed:
                                           return null;
                                 
                                         case LoadState.failed:
                                          return null;
                                     }
                                   },
                                 ),
                               ),
                               Positioned.fill(
                                 top: 5,
                                 left: 5,
                                 child: ListView.builder(
                                   itemCount: widget.postImg!.length,
                                   scrollDirection: Axis.horizontal,
                                   itemBuilder: (context, index) {
                                   
                                     if(index == itemIndex) {
                                     
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
                                 isUserPost: widget.isUserPost,
                                 name: widget.name,
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
                   // height: screenHeight * 0.5,
                   aspectRatio: (width/height) < (screenWidth/screenHeight) ? ((screenWidth/screenHeight)) : width/height //4/3 //aspectRatio //snapshot.data!.width / snapshot.data!.height,
                 ),
                             ),

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
                      // --------- implementation with reaction count --------
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            child: Icon(
                              Icons.bar_chart_rounded
                            ),
                            onTap: () {
                              
                              Navigator.of(context).push(
                                RouteTransAnim().createRoute(
                                  1.0, 0.0, 
                                  ReactedUsersList(
                                    postId: widget.id,
                                  )
                                )
                              );

                            },
                          ),
                          SizedBox(width: 8.0,),
                          if(userReaction == 'default')
                            GestureDetector(
                              child: Text(
                                '${widget.reactionCount}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0
                                ),
                              ),
                              onTap: () {
                      
                                // if(widget.isUserPost) {
                      
                                //   Navigator.of(context).push(
                                //     RouteTransAnim().createRoute(
                                //       1.0, 0.0, 
                                //       ReactedUsersList(
                                //         postId: widget.id,
                                //       )
                                //     )
                                //   );
                      
                                // }
                      
                              },
                            ),
                          if(userReaction != 'default')
                            GestureDetector(
                              child: Text(
                                '${userReaction == 'add' ? widget.reactionCount! + 1 : 
                                widget.reactionCount}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0
                                ),
                              ),
                              onTap: () {
                      
                                if(widget.isUserPost) {
                      
                                  Navigator.of(context).push(
                                    RouteTransAnim().createRoute(
                                      1.0, 0.0, 
                                      ReactedUsersList(
                                        postId: widget.id,
                                      )
                                    )
                                  );
                      
                                }
                      
                              },
                            ),
                          
                          IconButton(
                            icon: Icon(
                              widget.isReacted ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: widget.isReacted ? ColorTheme.primary : Colors.black,
                            ),
                            onPressed: () {
                      
                              if(!widget.isReacted) {
                                reactedPosts.addPostToReactedList(widget.id);
                                reactedPosts.removeFromRemovedReactionList(widget.id);
                      
                                setState(() {
                                  widget.isReacted = true;
                                  userReaction = 'add';
                                });
                      
                              } else {
                                reactedPosts.removePostFromReactedList(widget.id);
                                reactedPosts.addToRemovedReactionList(widget.id);
                                
                                setState(() {
                                  widget.isReacted = false;
                                  userReaction = 'remove';
                                });
                      
                              }
                      
                      
                      
                      
                              _interactionsReq.createReaction(reaction: Reaction(
                                post: widget.id, 
                                reaction: 1
                              ));
                      
                              // setState(() {
                              //   widget.isReacted = !widget.isReacted;
                              //   print('latestIsReacted ${widget.isReacted.toString()}');
                              //   // userReaction = 'remove';
                              // });
                      
                      
                            }, 
                          )
                        ],
                      )
                      // --------- End implementation with reaction count --------
                      // ---------------
                      // Row(
                      //   children: [
                      //     if(userReaction == 'default')
                      //       Text(
                      //         '${widget.reactionCount}',
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 12.0
                      //         ),
                      //       ),
                      //     if(userReaction != 'default')
                      //       Text(
                      //         '${userReaction == 'add' ? widget.reactionCount! + 1 : 
                      //         widget.reactionCount}',
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 12.0
                      //         ),
                      //       ),
                      //     widget.isReacted ? 
                      //     IconButton(
                      //       icon: Icon(
                      //         Icons.favorite_rounded,
                      //         color: ColorTheme.primary,
                      //       ),
                      //       onPressed: () {

                      //         _interactionsReq.createReaction(reaction: Reaction(
                      //           post: widget.id, 
                      //           reaction: 1
                      //         ));

                      //         setState(() {
                      //           widget.isReacted = false;
                      //           userReaction = 'remove';
                      //         });

                      //       }, 
                      //     ) : 
                      //     IconButton(
                      //       icon: Icon(
                      //         Icons.favorite_border_rounded,
                      //         color: Colors.black,
                      //       ),
                      //       onPressed: () {

                      //         _interactionsReq.createReaction(reaction: Reaction(
                      //           post: widget.id, 
                      //           reaction: 1
                      //         ));

                      //         setState(() {
                      //           widget.isReacted = true;
                      //           userReaction = 'add';
                      //         });

                      //       }, 
                      //     ),
                      //   ],
                      // )
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

  @override
  bool get wantKeepAlive => true;

  
}