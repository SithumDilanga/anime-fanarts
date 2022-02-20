import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/services/profile_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class UsersProfile extends StatefulWidget {

  final String? name;
  final String? userId;

  const UsersProfile({ Key? key, required this.name, required this.userId, }) : super(key: key);

  @override
  UsersProfileState createState() => UsersProfileState();
}

class UsersProfileState extends State<UsersProfile> with AutomaticKeepAliveClientMixin<UsersProfile> {

  // final Storage _storage = Storage();

  final picker = ImagePicker();
  var _profileImage;


  ProfileReq _profileReq = ProfileReq();
  // static const IMGURL = 'http://10.0.2.2:3000/img/users/';
  static const IMGURL = Urls.IMGURL;

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      print('_loadData');
    });
  }

  @override
  Widget build(BuildContext context) {

    print('userId ' + widget.userId.toString());

    return RefreshIndicator(
      onRefresh: _loadData,
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
            future: _profileReq.getUserById(id: '${widget.userId}'),
            builder: (context, snapshot) {

              if(snapshot.hasData) {

                dynamic userInfo = snapshot.data;
                dynamic userPosts = userInfo['posts'];

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
                              ConstrainedBox(
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
                                  // Image.network(
                                  //   'https://i.pinimg.com/originals/30/5c/5a/305c5a457807ba421ed67495c93198d3.jpg'
                                  // )
                                  // Image.network(
                                  //   'http://10.0.2.2:3000/img/users/${userInfo['coverPic']}'
                                  // )
                                      
                                  Image.network(
                                    '$IMGURL${userInfo['coverPic']}',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
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
                                          // NetworkImage(
                                          //   'http://10.0.2.2:3000/img/users/userPP-615eeaa924d6661b75313366-1633613125657.jpg'
                                          // )
                                          // https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000& q=80
                                              
                                          NetworkImage(
                                            '$IMGURL${userInfo['profilePic']}'
                                          )
                                              
                                        ),
                                      ),
                                      SizedBox(height: 4.0,),
                                      if(widget.userId == '621283374da8dc7d72b975bd')
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
                                      if(widget.userId != '621283374da8dc7d72b975bd')
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
                          if(widget.userId == '621283374da8dc7d72b975bd') 
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
                          if(widget.userId != '621283374da8dc7d72b975bd')
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
                      ListView.builder(
                        itemCount: userPosts.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                
                
                          return Post(
                            id: userPosts[index]['_id'],
                            name: userInfo['name'],
                            profilePic: '$IMGURL${userInfo['profilePic']}',
                            desc: userPosts[index]['description'],
                            postImg: [ '${userPosts[index]['postImages'][0]}' ],
                            userId: 'user123',
                            date: userPosts[index]['createdAt'],
                            reactionCount: userPosts[index]['reactions'][0]['reactionCount'],
                            commentCount: userPosts[index]['commentCount'][0]['commentCount'],
                            isUserPost: true
                          );
                
                          // var date = DateTime.parse(userPosts[index]['timestamp'].toDate().toString());
                          // var formattedDate = DateFormat.yMMMd().add_jm().format(date);
                
                          // if(userPosts[index]['postImg'] == null) {
              
                          //   return Post(
                          //     isUserPost: true,
                          //     id: userPosts[index]['postId'], //data.postId, 
                          //     name: userPosts[index]['name'],
                          //     profilePic: userInfo['profilePic'],
                          //     desc: userPosts[index]['desc'],
                          //     date: formattedDate.toString(),
                          //     userId: userPosts[index]['userId'],
                          //     reactionCount: userPosts[index]['reactionCount'],
                          //   );
                  
              
                          // }
              
                          // return Post(
                          //   isUserPost: true,
                          //   id: userPosts[index]['postId'], 
                          //   name: userPosts[index]['name'],
                          //   profilePic: userInfo['profilePic'],
                          //   desc: userPosts[index]['desc'],
                          //   postImg: userPosts[index]['postImg'],
                          //   date: formattedDate.toString(),
                          //   userId: userPosts[index]['userId'],
                          //   reactionCount: userPosts[index]['reactionCount'],
                          // );
                
                        }
                      )
                        //  Padding(
                        //   padding: const EdgeInsets.only(top: 16.0),
                        //   child: Center(
                        //     child: Text(
                        //       "You have't add any post yet!",
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 20
                        //       ),
                        //     )
                        //   ),
                        // ),
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