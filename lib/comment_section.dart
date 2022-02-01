import 'dart:io';

import 'package:anime_fanarts/profile/users_profile.dart';
import 'package:anime_fanarts/services/interactions.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/date_time_formatter.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/material.dart';

class CommentSecion extends StatefulWidget {

  final String? userId;
  final String? postId;

  const CommentSecion({ Key? key, required this.userId, required this.postId }) : super(key: key);

  @override
  _CommentSecionState createState() => _CommentSecionState();
}

class _CommentSecionState extends State<CommentSecion> {

  Interactions _interactionsReq = Interactions();
  static const IMGURL = 'http://10.0.2.2:3000/img/users/';
   DateTimeFormatter _dateTimeFormatter = DateTimeFormatter();

  final commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // shape: Border(
        //   bottom: BorderSide(
        //     color: Colors.grey,
        //     width: 1,
        //   )
        // ),
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
      ),
      body: FutureBuilder(
        future: _interactionsReq.getComments(widget.postId),
        builder: (context, snapshot) {

          if(snapshot.hasData) {

            dynamic comments = snapshot.data;

            return Padding(
            padding: const EdgeInsets.only(
              left: 4.0, right: 4.0, top: 4.0
            ),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blueGrey[700],
                              backgroundImage: FileImage(
                                File(SharedPref.getProfilePic()!)
                              )
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
                                Expanded(
                                  child: TextFormField(
                                    controller: commentTextController,
                                    cursorColor: ColorTheme.primary,
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
                                IconButton(
                                  icon: Icon(
                                    Icons.send_rounded,
                                    size: 28,
                                    color: ColorTheme.primary,
                                  ),
                                  onPressed: () {
                            
                                    _interactionsReq.addNewComment(
                                      commentTextController.text, 
                                      widget.postId
                                    );
                            
                                    setState(() {
                                      commentTextController.clear();
                                    });
                                      
                                  }, 
                                )
                              ],
                                                      ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          // child: Row(
                          //   children: [
                          //     Expanded(
                          //       child: TextFormField(
                          //         controller: commentTextController,
                          //         cursorColor: ColorTheme.primary,
                          //         decoration: InputDecoration(
                          //           focusedBorder: UnderlineInputBorder(
                          //             borderSide: BorderSide(color: ColorTheme.primary)
                          //           ),
                          //           // errorText: emailErrorText
                          //           hintText: 'Leave a comment...'
                          //         ),
                          //         style: TextStyle(
                          //           fontSize: 16
                          //         ),
                          //         // validation
                          //         validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                          //         onChanged: (val) {
                                    
                          //         },
                          //       ),
                          //     ),
                          //     IconButton(
                          //       icon: Icon(
                          //         Icons.send_rounded,
                          //         size: 28,
                          //         color: ColorTheme.primary,
                          //       ),
                          //       onPressed: () {

                          //         _interactionsReq.addNewComment(
                          //           commentTextController.text, 
                          //           widget.postId
                          //         );

                          //         setState(() {
                          //           commentTextController.clear();
                          //         });
          
                          //       }, 
                          //     )
                          //   ],
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: comments.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      String formattedDate = _dateTimeFormatter.getFormattedDateFromFormattedString(
                        value: comments[index]['user'][0]['createdAt'], 
                        currentFormat: "yyyy-MM-ddTHH:mm:ssZ", 
                        desiredFormat: "yyyy-MM-dd hh:mm a"
                      );

                    return Card(  
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.blueGrey[700],
                                        backgroundImage: NetworkImage(
                                          '$IMGURL${comments[index]['user'][0]['profilePic']}'
                                        ),
                                      ),
                                      SizedBox(width: 8.0,),
                                      Text(
                                        '${comments[index]['user'][0]['name']}',
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
                                        name: '${comments[index]['user'][0]['name']}', userId: comments[index]['user'][0]['_id'],))
                                    );
      
                                  },
                                ),
                                Text(
                                  '$formattedDate',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 8.0,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${comments[index]['comment']}'
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    },
                  ),
                )
              ],
            ),
          );

          }

          return Center(
            child: LoadingAnimation()
          );

        }
      ),
    );
  }
}