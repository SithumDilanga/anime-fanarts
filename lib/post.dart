import 'package:anime_fanarts/comment_section.dart';
import 'package:anime_fanarts/img_fullscreen.dart';
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
                              backgroundImage: AssetImage(
                                'assets/images/Gritie4.png'
                              )
                              // NetworkImage(
                              //   widget.profilePic,
                              // ),
                            ),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => UserProfile()),
                              // );
                              // Navigator.of(context).push(
                              //   RouteTransAnim().createRoute(1.0, .0, UserProfile())
                              // );
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
                                
                                  // Navigator.of(context).push(
                                  //   RouteTransAnim().createRoute(1.0, .0, UserProfile())
                                  // );

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
                GestureDetector(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 70,
                      minHeight: 70,
                      maxWidth: double.infinity,
                      maxHeight: 390,
                    ),
                    child: Container(
                      child: CachedNetworkImage(
                        imageUrl: widget.postImg!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => imagePlaceholder(),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImgFullScreen(imgLink: widget.postImg,)),
                    );
                  },
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