import 'dart:io';
import 'package:anime_fanarts/services/firestore_service.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/settings/guidelines.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/new_post_refresher.dart';

class AddNewArt extends StatefulWidget {
  const AddNewArt({ Key? key }) : super(key: key);

  @override
  _AddNewArtState createState() => _AddNewArtState();
}

class _AddNewArtState extends State<AddNewArt> {

  List<String> tagList = [];

  final tagTextController = TextEditingController();
  final descTextController = TextEditingController();

  final picker = ImagePicker();
  List? _postImages = [];

  final FirestoreService _firestireService = FirestoreService();

  GetCreatePosts _getCreatePosts = GetCreatePosts();

  Future _pickFanartImage() async {
    
    List<XFile>? pickedFiles = await picker.pickMultiImage(
      // source: ImageSource.gallery,
      imageQuality: 50
    );

    print('pickedFiles' + pickedFiles.toString());

    setState(() {
      // _postImages = File(pickedFiles.path);
      for(int i = 0; i < pickedFiles!.length; i++) {

        _postImages!.add(File(pickedFiles[i].path));

        print('_postImages' + _postImages.toString());

      }
    });

  }

  // Rate Alert Dialog
  Future<void> _rateAlert(String uid) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        double ratingValue = 0;

        return AlertDialog(
          title: const Text('How statisfied are you with Anime Fanarts?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: RatingBar(
                    initialRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 32,
                    ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star_rate_rounded,
                        color: Colors.amber[600],
                      ), 
                      half: Icon(
                        Icons.star,
                      ), 
                      empty: Icon(
                        Icons.star_border_rounded
                      ), 
                    ),
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    onRatingUpdate: (rating) {
                      ratingValue = rating;
                    },
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.amber[700],
                  fontSize: 18.0
                ),
              ),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.amber[50]),
              ),
              onPressed: () {

                if(ratingValue == 0) {
                  
                  Navigator.of(context).pop();

                  return null;
                }
                
                _firestireService.sendUserRating(ratingValue, uid)
                .whenComplete(() {

                  Fluttertoast.showToast(
                    msg: "Thanks for your feedback! It means a lot to us",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16.0
                  );

                  Navigator.of(context).pop();
                });
                

              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {

    var isNewPostAdded = Provider.of<NewPostFresher>(context);

    return FutureBuilder(
      future: _firestireService.readIsRateAvailable(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if(snapshot.hasData) {

          print('shit ${snapshot.data!['isRateAvailable']}');

          return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorTheme.primary,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded
              ),
              onPressed: () {
                Navigator.pop(context);
              }, 
            ),
            elevation: 0,
            title: Text(
              'Add new art'
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                if(_postImages!.isNotEmpty)
                  Column(
                    children: [
                      for(int i = 0; i < _postImages!.length; i++)
                      Column(
                        children: [
                          Image.file(
                            _postImages![i]
                          ),
                          SizedBox(height: 4.0,),
                        ],
                      ),
                      SizedBox(height: 8.0,),
                      Text(
                        '${_postImages!.length > 3 ? 'you can only add maximum up to 3 images' : '${_postImages!.length} / 3'}'
                      ),
                      SizedBox(height: 8.0,),
                      if(_postImages!.length > 3)
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  color: Colors.redAccent[700],
                                ),
                                SizedBox(width: 8.0,),
                                Text(
                                  'maximum image limit exceeds',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16
                                  ),
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(4)
                          ),
                        ),
                      SizedBox(height: 8.0,),
                    ],
                  ),
                  
                  // Image.file(
                  //   _postImages
                  // ),
                if(_postImages!.isEmpty)
                  Image.asset(
                    'assets/images/placeholder-image.png'
                  ),
                SizedBox(height: 4.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_circle_rounded,
                                color: Colors.black,
                                size: 28,
                              ),
                              SizedBox(width: 8.0,),
                              Text(
                                'Select Image',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                                ),
                              )
                            ],
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, //Color(0xffD8D8D8),
                          side: BorderSide(
                            width: 1.5,
                            color: ColorTheme.primary
                          )
                        ),
                        onPressed: () {
                          _pickFanartImage();
                        }, 
                      ),
                      SizedBox(height: 8.0,),
                      Text(
                        'Description', 
                        style: TextStyle(
                          fontSize: 18.0, 
                          color: Colors.black,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      TextFormField(
                        controller: descTextController,
                        cursorColor: ColorTheme.primary,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorTheme.primary)
                          ),
                          // errorText: emailErrorText
                          hintText: 'type description here...'
                        ),
                        style: TextStyle(
                          fontSize: 16
                        ),
                        // validation
                        validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                        onChanged: (val) {
                          
                        },
                      ),
                      SizedBox(height: 16.0,),
                      Text(
                        'Tags  ${tagList.length}/5', 
                        style: TextStyle(
                          fontSize: 18.0, 
                          color: Colors.black,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: tagTextController,
                                  cursorColor: ColorTheme.primary,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: ColorTheme.primary)
                                    ),
                                    // errorText: emailErrorText
                                    hintText: 'type tags here...'
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
                              SizedBox(width: 8.0,),
                              IconButton(
                                icon: Icon(
                                  Icons.add_box_rounded,
                                  color: ColorTheme.primary,
                                ),
                                onPressed: () {
                                  
                                  if(tagList.length < 5) {
    
                                    if(tagTextController.text.isEmpty) {
    
                                      Fluttertoast.showToast(
                                        msg: "No tag to add!",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        fontSize: 16.0
                                      );
    
                                    } else {
    
                                      setState(() {
                                        tagList.add(tagTextController.text);
                                      });
    
                                      tagTextController.clear();
    
                                    }
    
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "you can only add maximun 5 tags!",
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
                                  }
    
                                }, 
                              )
                            ],
                          ),
                          SizedBox(height: 8.0,),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  for(String tag in tagList)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorTheme.primary,
                                          borderRadius: BorderRadius.circular(32)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 4.0
                                          ),
                                          child: Text(
                                            '$tag',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  // SizedBox(width: 4.0,),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.amber[600],
                                  //     borderRadius: BorderRadius.circular(32)
                                  //   ),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.symmetric(
                                  //       horizontal: 8.0,
                                  //       vertical: 4.0
                                  //     ),
                                  //     child: Text(
                                  //       'gojo',
                                  //       style: TextStyle(
                                  //         fontSize: 11,
                                  //         color: Colors.white
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16.0,),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Make sure your artwork compliance with our ',
                            style: TextStyle(
                              color: Colors.black
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Guidelines',
                                style: TextStyle(
                                  color: ColorTheme.primary,
                                  decoration: TextDecoration.underline
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      RouteTransAnim().createRoute(
                                        1.0, 0.0, 
                                        GuideLines()
                                      )
                                    );
                                },
                              ),
                            ],
                          ), 
                        ),
                      ),
                      SizedBox(height: 24.0,),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0
                            ),
                            child: Text(
                              'POST',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: ColorTheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          onPressed: () {


                            if(_postImages!.length > 3) {
                              Fluttertoast.showToast(
                                msg: "Maximum image limit exceeds",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            } else if(tagList.isEmpty) {
                              print('culprit');
                              Fluttertoast.showToast(
                                msg: "please at least add one tag!",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            } else {

                              if(_postImages!.isNotEmpty) {

                                _getCreatePosts.createPost(
                                  postImageFile: _postImages,
                                  desc: descTextController.text,
                                  tags: tagList
                                ).whenComplete(() {

                                  Navigator.pop(context);

                                  isNewPostAdded.updateIsPostAdded(true);

                                });

                              } else {

                                Fluttertoast.showToast(
                                  msg: "please select your artwork!",
                                  toastLength: Toast.LENGTH_SHORT,
                                );

                              }

                            }
    
                          }, 
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        }

        return Material(
          child: LoadingAnimation()
        );

      }
    );
  }
}