import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UsersProfile extends StatefulWidget {
  const UsersProfile({ Key? key }) : super(key: key);

  @override
  UsersProfileState createState() => UsersProfileState();
}

class UsersProfileState extends State<UsersProfile> with AutomaticKeepAliveClientMixin<UsersProfile> {

  // final Storage _storage = Storage();

  final picker = ImagePicker();
  var _profileImage;
  var _coverImage;

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      print('_loadData');
    });
  }

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.amber[400],
      backgroundColor: Colors.amber[800],
      child: SafeArea(
        child: Scaffold(
          body: Container(
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
                                    
                                _coverImage == null ? Image.network(
                                  'https://pm1.narvii.com/8140/0fdca4b85e6cb881f592dda7294488878bde9541r1-750-250v2_hq.jpg',
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
                                            
                                        _profileImage == null ? NetworkImage(
                                          'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10'
                                        ) as ImageProvider : FileImage(
                                          _profileImage
                                        ),
                                            
                                      ),
                                    ),
                                    SizedBox(height: 4.0,),
                                    Text(
                                      'Levi Ackerman',
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
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                          child: Text(
                            'Donec et ligula nunc. Praesent porttitor, nisl quis egestas ultricies, nunc lorem laoreet lorem,',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),  
                    SizedBox(height: 24.0,), 
                    ListView.builder(
                      itemCount: 5,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
      
      
                        return Post(
                          id: '123',
                          name: 'Levi Ackerman',
                          profilePic: 'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10',
                          desc: 'marin kitagawa from my dress up darling',
                          postImg: 'https://images.alphacoders.com/120/thumb-1920-1203420.png',
                          userId: 'user123',
                          date: '15 jan 2022',
                          reactionCount: 4,
                          isUserPost: false
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
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}