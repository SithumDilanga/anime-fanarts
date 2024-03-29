import 'dart:io';
import 'package:anime_fanarts/profile/add_new_art.dart';
import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/profile/add_socials.dart';
import 'package:anime_fanarts/profile/admin_add_new_art.dart';
import 'package:anime_fanarts/services/profile_req.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/custom_icons.dart';
import 'package:anime_fanarts/utils/error_loading.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/urls.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_bio.dart';
import 'package:path_provider/path_provider.dart';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin<Profile> {

  static const animuzuId = Urls.animuzuUserId;

  final picker = ImagePicker();
  var _profileImage;
  var _coverImage;
  String? userId;

  TextEditingController? _changeName;

  ProfileReq _profileReq = ProfileReq();
  SharedPref _sharedPref = SharedPref();

   static const _pageSize = 5;
   List reactedPosts = [];
   List allPosts = [];

  final PagingController<int, dynamic> _pagingController = PagingController(firstPageKey: 1);

  void init() async {
    userId = await SecureStorage.getUserId();
  }


  @override
  void initState() {

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });


    // get userName from cache
    String? userName = SharedPref.getUserName();

    _changeName = TextEditingController(text: userName);

    init();

    super.initState();
  }

  void _fetchPage(int pageKey) async {

    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

    final allPostsData = await _profileReq.getUserPosts(
      pageKey,
      _pageSize
    );

     try {  

      final newItems = await allPostsData['data']['posts'];

      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // int nextPageKey = (pageKey + newItems.length) as int;
        int nextPageKey = (pageKey + 1);
        _pagingController.appendPage(newItems, nextPageKey);
      }

      setState(() {
        reactedPosts = reactedPosts + allPostsData['data']['reacted'];
      });

    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future _pickProfileImage() async {
    
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25
    );

    _cropProfileImage(pickedFile!.path);

  }

  // Crop Profile Image
  _cropProfileImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
    );

    if(croppedImage != null) {

      setState(() {
        _profileImage = croppedImage;
      });

      // add image to shared preferences

      Directory appDocDir = await getApplicationDocumentsDirectory();

      String path = appDocDir.path;

      final File newImage = await croppedImage.copy('$path/profileImage.png');

      SharedPref.setProfilePic(newImage.path);

      
    }
      _profileReq.uploadProfilePic(_profileImage);

  }

  // Crop Cover Image
  _cropCoverImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      // maxWidth: 1080,
      // maxHeight: 1080,
      aspectRatio: CropAspectRatio(ratioX: 5.0, ratioY: 2.0)
    );

    if(croppedImage != null) {

      setState(() {
        _coverImage = croppedImage;
      });
      
    }
      _profileReq.uploadCoverPic(_coverImage);

  }

  Future _pickCoverImage() async {
    
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25
    );

    _cropCoverImage(pickedFile!.path);

    // setState(() {
    //   // _coverImage = File(pickedFile!.path);
    //   _coverImage = File(pickedFile!.path);
    // });

    // add cover image to shared preferences
    // if(_coverImage != null) {

    //   Directory appDocDir = await getApplicationDocumentsDirectory();

    //   String path = appDocDir.path;

    //   final File newCoverImage = await _coverImage.copy('$path/coverImage.png');

    //   SharedPref.setCoverPic(newCoverImage.path);

    // }

    // _profileReq.uploadCoverPic(_coverImage).whenComplete(() {

    //   setState(() {
        
    //   });

    // });

  }

  // update name Alert Dialog
  Future<void> _updateNameAlert(String currentName) async {

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
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 40,
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
                  validator: (val) => val!.isEmpty ? 'Enter name' : null,
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

                  SharedPref.setUserName(_changeName!.text);

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

              },  
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);  

    return RefreshIndicator(
      onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
      ),
      color: Colors.blue[200],
      backgroundColor: ColorTheme.primary,
      child: FutureBuilder(
        future: Future.wait([
          _profileReq.getUser(),
          // _profileReq.getUserPosts()
        ]),
        builder: (context, AsyncSnapshot snapshot) {

          if(snapshot.hasData) {

            dynamic userInfo = snapshot.data[0];
            // dynamic userPosts = snapshot.data[1]['posts'];
            // dynamic userReactedPosts = snapshot.data[1]['reacted'];

            // ---- had to come up with logic in order fix the innapropriate space issue when there's no social platform added by the user -----

                String checkSocialPlatforms = '';

                if(userInfo['socialPlatforms'] != null) {
                  for(int i = 0; i < userInfo['socialPlatforms'].length; i++) {
                    checkSocialPlatforms = checkSocialPlatforms + userInfo['socialPlatforms'][i]['link'];
                  }
                }

            // --- End the logic ----

            if(userInfo != null) {

              Map<String, IconData> iconsMap = {
               'twitter': CustomIcons.twitter,
               'insta': CustomIcons.insta,
               'pinterest': CustomIcons.pinterest,
               'deviantArt': CustomIcons.deviantArt,
               'artstation': CustomIcons.artstation,
               'tiktok': CustomIcons.tiktok,
               'website': CustomIcons.website,
              };

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

                                    if(userInfo['coverPic'] == 'default-cover-pic.png')
                                      AspectRatio(
                                        aspectRatio: 5 / 2,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            // minHeight: 120,
                                            // maxHeight: 150,
                                            maxWidth: double.infinity
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6), 
                                              topRight: Radius.circular(6)
                                            ),
                                            child: 
                                            _coverImage == null ? Image.asset(
                                              'assets/images/cover-img-placeholder.jpg',
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ) : Image.file(
                                              _coverImage,
                                              width: double.infinity,
                                              fit: BoxFit.cover
                                            ),
                                          ),
                                        ),
                                      ),

                                      if(userInfo['coverPic'] != 'default-cover-pic.png')
                                        AspectRatio(
                                          aspectRatio: 5 / 2,
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              // minHeight: 120,
                                              // maxHeight: 150,
                                              maxWidth: double.infinity
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(6), 
                                                topRight: Radius.circular(6)
                                              ),
                                              child: 
                                              _coverImage == null ? ExtendedImage.network(
                                                '${userInfo['coverPic']}',
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                cache: true,
                                                cacheWidth: 500,
                                              ) : Image.file(
                                                _coverImage,
                                                width: double.infinity,
                                                fit: BoxFit.cover
                                              ),
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

                                          if(userInfo['profilePic'] == 'default-profile-pic.jpg')
                                            CircleAvatar(
                                              radius: 50,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 47,
                                                backgroundImage: 
                                                _profileImage == null ? AssetImage(
                                                  'assets/images/profile-img-placeholder.jpg'
                                                ) as ImageProvider : FileImage(
                                                  _profileImage
                                                ),

                                              ),
                                            ),

                                            if(userInfo['profilePic'] != 'default-profile-pic.jpg')
                                              CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius: 47,
                                                  backgroundImage: 
                                                  _profileImage == null ? ExtendedNetworkImageProvider(
                                                    '${userInfo['profilePic']}',
                                                    //cache: true,
                                                    retries: 3,
                                                    timeLimit: Duration(
                                                      milliseconds: 100
                                                    ),
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
                                          _updateNameAlert(userInfo['name']);
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
                                        onTap: () async {
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
                                    fontWeight: FontWeight.w500,
                                    height: 1.3
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0,),

                              // check whether user added at least one social platform
                              if(checkSocialPlatforms.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: GridView.count(
                                  shrinkWrap: true,
                                  primary: false,
                                  // padding: const EdgeInsets.all(20),
                                  // crossAxisSpacing: 10,
                                  // mainAxisSpacing: 10,
                                  crossAxisCount: 8,
                                  children: [
                                    if(userInfo['socialPlatforms'] != null)
                                    for(int i = 0; i < userInfo['socialPlatforms'].length; i++)
                                      if(userInfo['socialPlatforms'][i]['link'].isNotEmpty)
                                      Row(
                                        children: [
                                          InkWell(
                                            splashColor: Colors.grey,
                                            customBorder: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Icon(
                                                iconsMap['${userInfo['socialPlatforms'][i]['socialPlatform']}'],
                                                color: ColorTheme.primary,
                                                size: userInfo['socialPlatforms'][i]['socialPlatform'] == 'website' ? 18 : null
                                              ),
                                            ),
                                            onTap: () async {

                                              String url = '${userInfo['socialPlatforms'][i]['link']}';

                                              try {

                                                if(await canLaunch(url)){
                                                  await launch(
                                                    url, 
                                                    // forceWebView: true,
                                                    enableJavaScript: true
                                                  ); 
                                                } else {
                                                  throw 'Could not launch $url';
                                                }

                                              } catch(e) {

                                                throw(e);

                                              }

                                            },
                                          ),
                                        ],
                                      )
                                    
                                  ],
                                )
                                ),
                              ),
                              SizedBox(height: 16.0,),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                                child: Row(
                                  children: [
                                    Container(
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
                                                  Icons.person_add_alt_rounded,
                                                  color: Colors.black,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 4.0,),
                                                Text(
                                                  'Add Socials',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {

                                            if(userInfo['socialPlatforms'] != null) {

                                              Navigator.of(context).push(
                                                RouteTransAnim().createRoute(
                                                  0.0, 1.0, 
                                                  AddSocials(
                                                    socialPlatforms: userInfo['socialPlatforms'],
                                                  )
                                                )
                                              );

                                            }

                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8.0,),
                                    Container(
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
                                  ],
                                ),
                              ),
                              // if(user_id == '621283374da8dc7d72b975bd') 
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
                                      userId == animuzuId ? AdminAddNewArt() : AddNewArt(
                                        userId: userId,
                                      )
                                    )
                                  );

                                }, 
                              )
                            ],
                          ),  
                          SizedBox(height: 8.0,), 
                            PagedListView<int, dynamic>.separated(
                              pagingController: _pagingController,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              builderDelegate: PagedChildBuilderDelegate<dynamic>(
                                animateTransitions: true,
                                itemBuilder: (context, item, index) {

                                  // dynamic reactedPosts = snapshot.data['data']['reacted'];

                                  bool isReacted = false;


                                  for(int i = 0; i < reactedPosts.length; i++) {
                                  

                                    if(reactedPosts[i]['post'] == item['_id']) {
                                    
                                      isReacted = true;


                                    }

                                  }

                                  if(_pagingController.itemList == null) {

                                    return Padding(
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
                                    );

                                  }

                                  return Post(
                                    id: item['_id'],
                                    name: userInfo['name'],
                                    profilePic: '${userInfo['profilePic']}',
                                    desc: item['description'],
                                    postImg: item['postImages'],
                                    userId: item['user'],
                                    date: item['createdAt'],
                                    reactionCount: item['reactions'][0]['reactionCount'],
                                    commentCount: item['commentCount'][0]['commentCount'],
                                    isUserPost: true,
                                    isReacted: isReacted,
                                    // reactedPosts: []
                                  );

                                },
                                firstPageErrorIndicatorBuilder: (context) => ErrorLoading(
                                  errorMsg: 'Error loading posts: code #001', 
                                  onTryAgain: _pagingController.refresh
                                ) 
                                ,
                                noItemsFoundIndicatorBuilder: (context) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'No posts to show!',
                                      style: TextStyle(
                                        fontSize: 16.0
                                      ),
                                    ),
                                  ),
                                ),
                                newPageErrorIndicatorBuilder: (context) => ErrorLoading(
                                  errorMsg: 'Error loading posts: code #002', 
                                  onTryAgain: _pagingController.refresh
                                ),
                                firstPageProgressIndicatorBuilder: (context) => LoadingAnimation(),
                                newPageProgressIndicatorBuilder: (context) => LoadingAnimation(),
                                noMoreItemsIndicatorBuilder: (context) => 
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'No posts to show!',
                                      style: TextStyle(
                                        fontSize: 16.0
                                      ),
                                    ),
                                  ),
                                )
                              ),
                              separatorBuilder: (context, index) => const Divider(height: 0,),
                            ),
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