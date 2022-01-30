import 'dart:io';
import 'package:anime_fanarts/add_new_art.dart';
import 'package:anime_fanarts/models/profile_user.dart';
import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/services/profile_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gritie_new_app/gritie_share/post.dart';
// import 'package:gritie_new_app/models/uid.dart';
// import 'package:gritie_new_app/services/database.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
// import 'package:gritie_new_app/services/storage.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:gritie_new_app/auth/log_in.dart';
// import 'package:gritie_new_app/auth/sign_up.dart';
// import 'package:gritie_new_app/models/profile_user.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'edit_bio.dart';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin<Profile> {

  static const IMGURL = 'http://10.0.2.2:3000/img/users/';

  final picker = ImagePicker();
  var _profileImage;
  var _coverImage;

  TextEditingController? _changeName;

  ProfileReq _profileReq = ProfileReq();

  @override
  void initState() {

    // get userName from cache
    String? userName = SharedPref.getUserName();

    _changeName = TextEditingController(text: userName);

    super.initState();
  }

  Future _pickProfileImage() async {
    
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50
    );

    setState(() {
      // _profileImage = File(pickedFile!.path);
      _profileImage = File(pickedFile!.path);
    });

    _profileReq.uploadProfilePic(_profileImage);

  }

  Future _pickCoverImage() async {
    
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50
    );

    setState(() {
      // _coverImage = File(pickedFile!.path);
      _coverImage = File(pickedFile!.path);
    });

    _profileReq.uploadCoverPic(_coverImage).whenComplete(() {

      setState(() {
        
      });

    });

  }

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      print('_loadData');
    });
  }


  // update name Alert Dialog
  Future<void> _updateNameAlert() async {

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          title: const Text('Chane your Name '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _changeName,
                  cursorColor: ColorTheme.primary,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorTheme.primary)
                    ),
                    // hintText: 'Enter your Email'
                  ),
                  style: TextStyle(
                    fontSize: 18
                  ),
                  // validation
                  validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                ),
              ],
            ),
          ),
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

                _profileReq.updateUsername(_changeName!.text)
                .onError((error, stackTrace) {

                  Fluttertoast.showToast(
                    msg: "Error Occured : $error",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16.0
                  );

                }).whenComplete(() {

                  Fluttertoast.showToast(
                    msg: "Your public name changed to ${_changeName!.text}",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16.0
                  );

                  Navigator.of(context).pop();

                  setState(() {
                    
                  });

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

  @override
  Widget build(BuildContext context) {

    // var profileData = Provider.of<ProfileUser>(context);

    // print('profileData ${profileData.bio}');

    // final user = Provider.of<UID?>(context, listen: false);

    // if(user == null) {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [ 
    //       ElevatedButton( 
    //         child: Text(
    //           'SIGN UP', 
    //           style: TextStyle(
    //             fontSize: 16.0, 
    //             color: Colors.black
    //           ),
    //         ),
    //         style: ElevatedButton.styleFrom(
    //           primary: Colors.white,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(25),
    //           ),
    //           side: BorderSide(
    //             color: Colors.black,
    //             width: 1.5
    //           ),
    //           padding: EdgeInsets.fromLTRB(66.0, 16.0, 66.0, 16.0),
    //         ),
    //         onPressed:() {

    //           Navigator.of(context).push(
    //             RouteTransAnim().createRoute(
    //               -1.0, 0.0, 
    //               SignUp()
    //             )
    //           );

    //         }
    //       ),
    //       SizedBox(height: 16.0,),
    //       Text(
    //         'If you already have an account',
    //         style: TextStyle(
    //           fontSize: 16,
    //           color: Colors.amber[600],
    //           fontWeight: FontWeight.w500
    //         ),
    //       ),
    //       SizedBox(height: 16.0,),
    //       ElevatedButton( 
    //         child: Text(
    //           'LOGIN', 
    //           style: TextStyle(
    //             fontSize: 16.0, 
    //             color: Colors.black
    //           ),
    //         ),
    //         style: ElevatedButton.styleFrom(
    //           primary: Colors.white,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(25),
    //           ),
    //           side: BorderSide(
    //             color: Colors.black,
    //             width: 1.5
    //           ),
    //           padding: EdgeInsets.fromLTRB(66.0, 16.0, 66.0, 16.0),
    //         ),
    //         onPressed:() {

    //           Navigator.of(context).push(
    //             RouteTransAnim().createRoute(
    //               -1.0, 0.0, 
    //               Login()
    //             )
    //           );

    //         }
    //       )
    //     ]
    //   );
    // }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.blue[200],
      backgroundColor: ColorTheme.primary,
      child: FutureBuilder(
        future: Future.wait([
          _profileReq.getUser(),
          _profileReq.getUserPosts()
        ]),
        builder: (context, AsyncSnapshot snapshot) {

          if(snapshot.hasData) {

            dynamic userInfo = snapshot.data[0];
            dynamic userPosts = snapshot.data[1]['posts'];
            dynamic userReactedPosts = snapshot.data[1]['reacted'];

            if(userInfo != null) {

              return Material(
                child: Container(
                  color: Color(0xffF0F0F0),
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
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
                                  
                                  if(userInfo['coverPic'] == null)
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
                                        child: Container(
                                          color: Colors.grey[300],
                                        )                                  
                                      ),
                                    ),

                                  if(userInfo['coverPic'] != null)
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

                                        //https://pm1.narvii.com/8140/0fdca4b85e6cb881f592dda7294488878bde9541r1-750-250v2_hq.jpg

                                        _coverImage == null ? Image.network(
                                          '$IMGURL${userInfo['coverPic']}',
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ) : Image.file(
                                          _coverImage,
                                          width: double.infinity,
                                          fit: BoxFit.cover
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4.0, right: 6.0),
                                      child: InkWell(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(4)
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.camera_alt_rounded,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4.0,),
                                              Text(
                                                'Cover',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          _pickCoverImage();
                                        },
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
                                              // NetworkImage(
                                              //   'http://10.0.2.2:3000/img/users/userPP-615eeaa924d6661b75313366-1633613125657.jpg'
                                              // )
                                              // https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10

                                              _profileImage == null ? NetworkImage(
                                                '$IMGURL${userInfo['profilePic']}'
                                              ) as ImageProvider : FileImage(
                                                _profileImage
                                              ),

                                            ),
                                          ),
                                          SizedBox(height: 4.0,),
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
                              SizedBox(height: 8.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4.0,),
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                  fontSize: 11
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          _updateNameAlert();
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.camera_alt_rounded,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4.0,),
                                              Text(
                                                'Profile',
                                                style: TextStyle(
                                                  fontSize: 11
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          _pickProfileImage();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              //TODO: find some other way to make a margin here
                              SizedBox(height: 64.0,),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                                child: Text(
                                  '${userInfo['bio'] == null ? 'Add bio' : userInfo['bio']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.0,),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4.0,),
                                          Text(
                                            'Edit Bio',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditBio(
                                            bioText: '${userInfo['bio'] == null ? '' : userInfo['bio']}',
                                            uid: '123',
                                          )
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_circle_rounded,
                                      color: ColorTheme.primary,
                                      size: 28,
                                    ),
                                    SizedBox(width: 8.0,),
                                    Text(
                                      'Add new art',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16
                                      ),
                                    )
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                onPressed: () {
                                
                                  Navigator.of(context).push(
                                    RouteTransAnim().createRoute(
                                      1.0, 1.0, 
                                      AddNewArt()
                                    )
                                  );

                                }, 
                              )
                            ],
                          ),  
                          SizedBox(height: 8.0,), 
                          if(userPosts.isEmpty) 
                            Padding(
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
                            ),
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
                                postImg: ['${userPosts[index]['postImages'][0]}'],
                                userId: userPosts[index]['_id'],
                                date: userPosts[index]['createdAt'],
                                reactionCount: userPosts[index]['reactions'][0]['reactionCount'],
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
                      ),
                    )

                  ),
                ),
              );

            }

          }

          return Padding(
            padding: const EdgeInsets.only(top: 128),
            child: LoadingAnimation(),
          );

        }
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}