import 'dart:io';
import 'package:anime_fanarts/main.dart';
import 'package:anime_fanarts/services/fcm.dart';
import 'package:anime_fanarts/services/firestore_service.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/settings/guidelines.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddNewArt extends StatefulWidget {

  final userId;

  const AddNewArt({ Key? key, required this.userId }) : super(key: key);

  @override
  _AddNewArtState createState() => _AddNewArtState();
}

class _AddNewArtState extends State<AddNewArt> {

  List<String> tagList = [];

  final tagTextController = TextEditingController();
  final descTextController = TextEditingController();

  String? currentUserName = '';

  final picker = ImagePicker();
  List? _postImages = [];

  final FirestoreService _firestireService = FirestoreService();

  GetCreatePosts _getCreatePosts = GetCreatePosts();
  FirebaseCloudMessaging _fcm = FirebaseCloudMessaging();

  bool isLoading = false;

  Future _pickFanartImage() async {
    
    List<XFile>? pickedFiles = await picker.pickMultiImage(
      // source: ImageSource.gallery,
      imageQuality: 75
    );
    

    setState(() {
      // _postImages = File(pickedFiles.path);
      for(int i = 0; i < pickedFiles!.length; i++) {

        File selectedImage = File(pickedFiles[i].path);

        print('imgLength ${selectedImage.lengthSync()/1024} KB');

        if(selectedImage.lengthSync()/1024 > 1024) {

          secondImgCompression(selectedImage, pickedFiles[i].path);
          
        } else {

          _postImages!.add(File(pickedFiles[i].path));

        }


        // print('imgLength ${selectedImage.readAsBytesSync().lengthInBytes/1024}');

        // testCompressAndGetFile(selectedImage, pickedFiles[i].path);

        // lubanImgCompression(selectedImage);

        // nativeImgCompress(selectedImage);

      }
    });

  }

  // ---------- flutter_image_compress image compression package -----------

  Future<File> secondImgCompression(File file, String targetPath) async {

    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'(.png|.jp)'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    print('outPath $outPath');

    FlutterImageCompress.validator.ignoreCheckExtName = true;

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, 
      outPath,
      quality: 95,
    );

    print('path $outPath');

    print('lengthSync() ${file.readAsBytesSync().lengthInBytes/1024}');
    print('result!.lengthSync() ${result!.readAsBytesSync().lengthInBytes/1024}');
    
    _postImages!.add(result);

    return result;
  }

  // ---------- End flutter_image_compress image compression package -----------

  // ---------- lubam image compression package -----------

  // Future lubanImgCompression(File imgFile) async {

  //   final filePath = imgFile.absolute.path;

  //   final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
  //   final splitted = filePath.substring(0, (lastIndex));
  //   final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

  //   String path = '/data/user/0/com.animizu/cache';

  //   CompressObject compressObject = CompressObject(
  //        imageFile: imgFile, //image
  //        path: path, //compress to path
  //        quality: 80,//first compress quality, default 80
  //        step: 2,//compress quality step, The bigger the fast, Smaller is more accurate, default 6
  //        mode: CompressMode.LARGE2SMALL,//default AUTO
  //      );

  //   Luban.compressImage(compressObject).then((_path) {
  //       // setState(() {
  //         print('_path $_path');
  //       // });
  //       print('compressObject ${compressObject.imageFile}');


  //       setState(() {
  //         File selectedImage = File(_path!);
  //         _postImages!.add(selectedImage);
  //       });
  //   });

  // }

  // ---------- End lubam image compression package -----------

  // ---------- nativeImageCompress image compression package -----------

  // Future nativeImgCompress(File imgFile) async {

  //   File compressedFile = await FlutterNativeImage.compressImage(imgFile.path,
  //   quality: 100, percentage: 70);

  //   print('compressedFile $compressedFile');

  //   setState(() {
  //     _postImages!.add(compressedFile);
  //   });

  // }

  // ---------- End nativeImageCompress image compression package -----------

  // Rate Alert Dialog
  Future<void> _rateAlert(String uid) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        double ratingValue = 0;

        return AlertDialog(
          title: const Text('How statisfied are you with Animizu?'),
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

  // post add confirmation Alert Dialog
  Future<void> _addPostAlert(BuildContext context, isRateAvailable) async {

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Are you sure want to add this post ?'),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    isLoading ? '' : 'CANCEL',
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
                isLoading ? 
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: ColorTheme.primary,
                    fontSize: 18.0
                  ),
                ) :
                TextButton(
                  child: Text(
                    'YES',
                    style: TextStyle(
                      color: ColorTheme.primary,
                      fontSize: 18.0
                    ),
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.blue[50]),
                  ),
                  onPressed: () {

                    setState(() {
                      isLoading = true;
                    });

                      try {

                        _getCreatePosts.createPost(
                          postImageFile: _postImages,
                          desc: descTextController.text,
                          tags: tagList
                        ).whenComplete(() {

                          _fcm.sendPushNotificationToSubs(
                            artistName: currentUserName
                          );

                          if(isRateAvailable) {

                            Future.delayed(const Duration(milliseconds: 5), () {
                              _rateAlert(widget.userId);
                            });
                              
                          }

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp(selectedPage: 1)),
                            (Route<dynamic> route) => false,
                          );

                        });
                        

                      } catch(e) {

                        Fluttertoast.showToast(
                          msg: "Error $e",
                          toastLength: Toast.LENGTH_SHORT,
                        );

                      }

                  },  
                ),
              ],
            );
          }
        );
      },
    );
  }

  void init() async {
    currentUserName = SharedPref.getUserName();
  }

  @override
  void initState() {
    
    init();

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    // var isNewPostAdded = Provider.of<NewPostFresher>(context);

    return FutureBuilder(
      future: _firestireService.readIsRateAvailable(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if(snapshot.hasData) {

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
                        validator: (val) => val!.isEmpty ? 'Enter Description' : null,
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
                                  validator: (val) => val!.isEmpty ? 'Enter Tags' : null,
                                  inputFormatters: [
                                    // not letting user add # symbol
                                    FilteringTextInputFormatter.deny(
                                      RegExp("#")
                                    ),
                                    // not letting user add white spaces
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s')
                                    ),
                                  ],
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
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                          child: Row(
                                            children: [
                                              Text(
                                                '$tag',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white
                                                ),
                                              ),
                                              SizedBox(width: 4.0,),
                                              GestureDetector(
                                                child: Icon(
                                                  Icons.close_rounded,
                                                  size: 11,
                                                ),
                                                onTap: () {
                              
                                                  setState(() {
                                                    tagList.remove(tag);
                                                  });
                              
                              
                                                },
                                              )
                                            ],
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
                              Fluttertoast.showToast(
                                msg: "please at least add one tag!",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            } else {

                              if(_postImages!.isNotEmpty) {

                                 if(_postImages!.length > 3) {
                                    Fluttertoast.showToast(
                                      msg: "Maximum image limit exceeds!",
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
                                  } else if(tagList.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: "Please at least add one tag!",
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
                                  } else {

                                    _addPostAlert(
                                      context, 
                                      snapshot.data!['isRateAvailable']
                                    );

                                  }


                                // try {

                                //   _getCreatePosts.createPost(
                                //     postImageFile: _postImages,
                                //     desc: descTextController.text,
                                //     tags: tagList
                                //   );

                                //     Fluttertoast.showToast(
                                //       msg: "Post added successfully!",
                                //       toastLength: Toast.LENGTH_SHORT,
                                //     );

                                //     Navigator.pop(context);

                                //     isNewPostAdded.updateIsPostAdded(true);



                                // } catch(e) {

                                //   Fluttertoast.showToast(
                                //     msg: "Error $e",
                                //     toastLength: Toast.LENGTH_SHORT,
                                //   );

                                // }


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