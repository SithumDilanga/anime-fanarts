import 'package:anime_fanarts/main.dart';
import 'package:anime_fanarts/services/profile_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/custom_icons.dart';
import 'package:flutter/material.dart';

class AddSocials extends StatefulWidget {

  final List socialPlatforms;

  const AddSocials({ Key? key, required this.socialPlatforms }) : super(key: key);

  @override
  State<AddSocials> createState() => _AddSocialsState();
}

class _AddSocialsState extends State<AddSocials> {

  ProfileReq _profileReq = ProfileReq();

  String twitterText = '';
  String instaText = '';
  String pinterestText = '';
  String deviantArtText = '';
  String artstationText = '';
  String tiktokText = '';
  String websiteText = '';

  // ---------- validation functions --------------

  String? get twitterErrorText {

    if (!twitterText.contains('twitter.com') && twitterText.isNotEmpty) {
      return 'Invalid twitter link';
    } 

    if(!twitterText.contains('https://') && twitterText.isNotEmpty) {
      return 'You must include https:// at the beginning';
    }

    return null;
  }

  String? get instaTextErrorText {

    if (!instaText.contains('instagram.com') && instaText.isNotEmpty) {
      return 'Invalid instagram link';
    } 

    if(!instaText.contains('https://') && instaText.isNotEmpty) {
      return 'You must include https:// at the beginning';
    }

    return null;
  }

  String? get pinterestErrorText {

    if (!pinterestText.contains('pin.it') && pinterestText.isNotEmpty) {

      if(pinterestText.contains('pinterest.com')) {

        if(!pinterestText.contains('https://') && pinterestText.isNotEmpty) {
          return 'You must include https:// at the beginning';
        }

        return null;
      }

      return 'Invalid pinterest link';
    } 

    if(!pinterestText.contains('https://') && pinterestText.isNotEmpty) {
      return 'You must include https:// at the beginning';
    }

    return null;
  }

  String? get deviantArtTextErrorText {

    if (!deviantArtText.contains('deviantart.com') && deviantArtText.isNotEmpty) {
      return 'Invalid deviantArt link';
    } 

    if(!deviantArtText.contains('https://') && deviantArtText.isNotEmpty) {
      return 'You must include https:// at the beginning';
    }

    return null;
  }

  String? get artStationTextErrorText {

    if (!artstationText.contains('artstation.com') && artstationText.isNotEmpty) {
      return 'Invalid artStation link';
    } 

    if(!artstationText.contains('https://') && artstationText.isNotEmpty) {
      return 'You must include https:// at the beginning';
    }

    return null;
  }

  String? get tikTokTextErrorText {

    if (!tiktokText.contains('tiktok.com') && tiktokText.isNotEmpty) {
      return 'Invalid TikTok link';
    } 

    if(!tiktokText.contains('https://') && tiktokText.isNotEmpty) {
      return 'You must include https:// at the beginning';
    }

    return null;
  }

  String? get webSiteTextErrorText {

    if(!websiteText.contains('https://') && websiteText.isNotEmpty) {
      return 'You must include https:// at the beginning';
    }

    return null;
  }

  // ---------- End validation functions --------------

  // this was created for checking when the user want to fully remove an added link
  List isEditedList = [
    {
      'socialPlatform': 'twitter',
      'isEdited': false
    },
    {
      'socialPlatform': 'insta',
      'isEdited': false
    },
    {
      'socialPlatform': 'pinterest',
      'isEdited': false
    },
    {
      'socialPlatform': 'deviantArt',
      'isEdited': false
    },
    {
      'socialPlatform': 'artstation',
      'isEdited': false
    },
    {
      'socialPlatform': 'tiktok',
      'isEdited': false
    },
    {
      'socialPlatform': 'website',
      'isEdited': false
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


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
        title: Text(
          'Add Socials'
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 12.0, 10.0),
            child: ElevatedButton(
              child: Text(
                'Save'
              ),
              style: ElevatedButton.styleFrom(
                primary: ColorTheme.primary,
                elevation: 0,
                side: BorderSide(
                  width: 1.5, 
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: (
                twitterErrorText == null &&
                instaTextErrorText == null &&
                pinterestErrorText == null &&
                deviantArtTextErrorText == null &&
                artStationTextErrorText == null &&
                tikTokTextErrorText == null &&
                webSiteTextErrorText == null
              ) ? () {

                print('tiktok $tiktokText');

                _profileReq.updateSocialPlatforms(
                  // check whether typed text is empty and specific social platform is not added
                  twitter: (twitterText.isEmpty && widget.socialPlatforms[0]['link'].isEmpty || 

                  // check whether typed text is empty and specific social platform is not added and is user removed that specific link or changed it
                  (twitterText.isEmpty && widget.socialPlatforms[0]['link'].isNotEmpty && isEditedList[0]['isEdited'] == false)) 
                  ? widget.socialPlatforms[0]['link'] 
                  : twitterText,

                  insta: (instaText.isEmpty && widget.socialPlatforms[1]['link'].isEmpty || (instaText.isEmpty && widget.socialPlatforms[1]['link'].isNotEmpty && isEditedList[1]['isEdited'] == false)) 
                  ? widget.socialPlatforms[1]['link'] 
                  : instaText,

                  pinterest: (pinterestText.isEmpty && widget.socialPlatforms[2]['link'].isEmpty || (pinterestText.isEmpty && widget.socialPlatforms[2]['link'].isNotEmpty && isEditedList[2]['isEdited'] == false)) 
                  ? widget.socialPlatforms[2]['link'] 
                  : pinterestText,
                  
                  deviatArt: (deviantArtText.isEmpty && widget.socialPlatforms[3]['link'].isEmpty || (deviantArtText.isEmpty && widget.socialPlatforms[3]['link'].isNotEmpty && isEditedList[3]['isEdited'] == false)) 
                  ? widget.socialPlatforms[3]['link'] 
                  : deviantArtText,

                  artstation: (artstationText.isEmpty && widget.socialPlatforms[4]['link'].isEmpty || (artstationText.isEmpty && widget.socialPlatforms[4]['link'].isNotEmpty && isEditedList[4]['isEdited'] == false)) 
                  ? widget.socialPlatforms[4]['link'] 
                  : artstationText,

                  tiktok: (tiktokText.isEmpty && widget.socialPlatforms[5]['link'].isEmpty || (tiktokText.isEmpty && widget.socialPlatforms[5]['link'].isNotEmpty && isEditedList[5]['isEdited'] == false)) 
                  ? widget.socialPlatforms[5]['link']
                  : tiktokText,

                  website: (websiteText.isEmpty && widget.socialPlatforms[6]['link'].isEmpty || (websiteText.isEmpty && widget.socialPlatforms[6]['link'].isNotEmpty && isEditedList[6]['isEdited'] == false)) 
                  ? widget.socialPlatforms[6]['link'] 
                  : websiteText

                ).whenComplete(() {

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp(selectedPage: 1)),
                      (Route<dynamic> route) => false,
                    );

                });

              } : null, 
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        CustomIcons.twitter,
                        color: ColorTheme.primary,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        'Twitter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    initialValue: widget.socialPlatforms[0]['link'] ?? '',
                    cursorColor: ColorTheme.primary,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      errorText: twitterErrorText 
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    onChanged: (val) {
                      setState(() {
                        twitterText = val;
                      });

                      // set isEdited to true while typing
                      isEditedList[0]['isEdited'] = true;
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.0,),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        CustomIcons.insta,
                        color: ColorTheme.primary,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        'Instagram',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    initialValue: widget.socialPlatforms[1]['link'] ?? '',
                    cursorColor: ColorTheme.primary,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      errorText: instaTextErrorText
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    onChanged: (val) {

                      setState(() {
                        instaText = val;
                      });

                      isEditedList[1]['isEdited'] = true;
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.0,),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        CustomIcons.pinterest,
                        color: ColorTheme.primary,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        'Pinterest',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    initialValue: widget.socialPlatforms[2]['link'] ?? '',
                    cursorColor: ColorTheme.primary,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      errorText: pinterestErrorText
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    onChanged: (val) {

                      setState(() {
                        pinterestText = val;
                      });

                      isEditedList[2]['isEdited'] = true;
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.0,),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        CustomIcons.deviantArt,
                        color: ColorTheme.primary,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        'DeviantArt',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    initialValue: widget.socialPlatforms[3]['link'] ?? '',
                    cursorColor: ColorTheme.primary,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      errorText: deviantArtTextErrorText
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    onChanged: (val) {

                      setState(() {
                        deviantArtText = val;
                      });

                      isEditedList[3]['isEdited'] = true;
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.0,),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        CustomIcons.artstation,
                        color: ColorTheme.primary,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        'ArtStation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    initialValue: widget.socialPlatforms[4]['link'] ?? '',
                    cursorColor: ColorTheme.primary,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      errorText: artStationTextErrorText
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    onChanged: (val) {

                      setState(() {
                        artstationText = val;
                      });

                      isEditedList[4]['isEdited'] = true;
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.0,),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        CustomIcons.tiktok,
                        color: ColorTheme.primary,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        'TikTok',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    initialValue: widget.socialPlatforms[5]['link'] ?? '',
                    cursorColor: ColorTheme.primary,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      errorText: tikTokTextErrorText
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    onChanged: (val) {

                      setState(() {
                        tiktokText = val;
                      });

                      isEditedList[5]['isEdited'] = true;
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.0,),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        CustomIcons.website,
                        size: 18,
                        color: ColorTheme.primary,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        'Website',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    initialValue: widget.socialPlatforms[6]['link'] ?? '',
                    cursorColor: ColorTheme.primary,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      errorText: webSiteTextErrorText
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    onChanged: (val) {

                      setState(() {
                        websiteText = val;
                      });

                      isEditedList[6]['isEdited'] = true;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SocialItem extends StatelessWidget {

//   final String platformName;
//   final String platformLink;

//   const SocialItem({ Key? key, required this.platformName, required this.platformLink,}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Icon(
//               CustomIcons.website,
//               size: 18,
//               color: ColorTheme.primary,
//             ),
//             SizedBox(width: 8.0,),
//             Text(
//               '$platformName',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold
//               ),
//             )
//           ],
//         ),
//         TextFormField(
//           initialValue: platformLink,
//           cursorColor: ColorTheme.primary,
//           keyboardType: TextInputType.multiline,
//           maxLines: null,
//           decoration: InputDecoration(
//             //hintText: 'Enter your Password'
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: ColorTheme.primary)
//             ),
//           ),
//           style: TextStyle(
//             fontSize: 18
//           ),
//         ),
//         SizedBox(height: 24.0,),
//       ],
//     );
//   }
// }