import 'package:anime_fanarts/comment_section.dart';
import 'package:anime_fanarts/img_fullscreen.dart';
import 'package:anime_fanarts/profile/users_profile.dart';
import 'package:anime_fanarts/report/select_reason.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gritie_new_app/utils/loading_animation.dart';
// import 'package:gritie_new_app/utils/route_trans_anim.dart';
// import 'package:gritie_new_app/services/shared_pref.dart';
// // import 'package:gritie_new_app/gritie_features/user_profile.dart';
// import 'package:gritie_new_app/services/database.dart';
// import 'package:gritie_new_app/utils/initialLetters.dart';
import 'package:readmore/readmore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Post extends StatefulWidget {

  final String? id;
  final String? name;
  final String? profilePic;
  final String? desc;
  final String? postImg;
  final String? userId;
  final String? date;
  final int? reactionCount;
  final bool isUserPost;

   Post({ Key? key, this.id, this.name, this.profilePic, this.desc = '', this.postImg = '', this.userId, this.date, this.reactionCount, this.isUserPost = false}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {

  bool isReacted = false;

  // final DatabaseService _database = DatabaseService();
  // final InitialLetters _initialLetters = InitialLetters();

  static const primaryColor = Color(0xffffa500); 

  List imageList = ['https://images.alphacoders.com/120/thumb-1920-1203420.png', 'https://i.pinimg.com/originals/44/c3/21/44c321cf6862f22caf3e6b71a0661565.jpg','https://www.nawpic.com/media/2020/levi-ackerman-nawpic-17.jpg' ];

  // update name Alert Dialog
  Future<void> _deletPostAlert() async {

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

  @override
  Widget build(BuildContext context) {

    String userName = widget.name.toString();
    print('userName ' + userName);

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
                                RouteTransAnim().createRoute(1.0, .0, UsersProfile(name: widget.name,))
                              );
                            },
                          ),
                        SizedBox(width: 8.0,),
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
                                    RouteTransAnim().createRoute(1.0, .0, UsersProfile(name: widget.name))
                                  );

                                },
                              ),
                            Text(
                              widget.date!,
                              style: TextStyle(
                                fontSize: 11.0
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  if(widget.isUserPost)
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: ColorTheme.primary,
                      ),
                      onPressed: () {

                        _deletPostAlert();

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
                            0.0, 1.0, 
                            SelectReason()
                          )
                        );

                      } else if(selection == 1) {
                      
                        // _updateNameAlert();

                      } else if(selection == 3) {
                      
                        // _authService.logOut();

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
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8.0,),
                            Text(
                              'Share',
                            ),
                          ],
                        ),
                        value: 1
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(
                              Icons.download_rounded,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8.0,),
                            Text(
                              'Save',
                            ),
                          ],
                        ),
                        value: 1
                      ),
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
              if(widget.desc!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                  // child: Text(
                  //   widget.desc,
                  //   style: TextStyle(
                  //     fontSize: 16.0
                  //   ),
                  // ),
                  child: ReadMoreText(
                    widget.desc!.replaceAll('/n', '\n \n'),
                    trimLines: 3,
                    colorClickableText: primaryColor,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      height: 1.3
                    ),
                    moreStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 16.0
                    ),
                  ),
                ),
              if(widget.postImg!.isNotEmpty)

                CarouselSlider.builder(
                  itemCount: imageList.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    return GestureDetector(
                      child: Stack(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 70,
                              minHeight: 70,
                              maxWidth: double.infinity,
                              maxHeight: 390,
                            ),
                            child: Container(
                              child: CachedNetworkImage(
                                imageUrl: imageList[itemIndex].toString(),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => imagePlaceholder(),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            top: 5,
                            left: 5,
                            child: ListView.builder(
                              itemCount: imageList.length,
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
                                        '${index + 1}/${imageList.length}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 0.8
                                          ..color = Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '${index + 1}/${imageList.length}',
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
                      onTap: () {

                        // imgLink: imageList[itemIndex].toString()

                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ImgFullScreen(
                            imageList: imageList, 
                            selectedimageIndex: itemIndex, 
                            imgLink: imageList[itemIndex],
                          )),
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
                              'comments 4',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: isReacted ? primaryColor : Colors.white,
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
    
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CommentSecion()),
                          );

                        },
                      ),
                      Row(
                        children: [
                          Text(
                            '8',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border_rounded
                            ),
                            onPressed: () {

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