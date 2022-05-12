import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/custom_icons.dart';
import 'package:flutter/material.dart';

class AddSocials extends StatefulWidget {
  const AddSocials({ Key? key }) : super(key: key);

  @override
  State<AddSocials> createState() => _AddSocialsState();
}

class _AddSocialsState extends State<AddSocials> {

  TextEditingController twitterTextController = TextEditingController();
  TextEditingController instaTextController = TextEditingController();
  TextEditingController tiktokTextController = TextEditingController();
  TextEditingController deviantArtTextController = TextEditingController();
  TextEditingController websiteTextController = TextEditingController();

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
              onPressed: () {

                if(
                  twitterTextController.text.isNotEmpty || 
                  instaTextController.text.isNotEmpty ||
                  tiktokTextController.text.isNotEmpty ||
                  deviantArtTextController.text.isNotEmpty ||
                  websiteTextController.text.isNotEmpty) {

                    

                }

                Navigator.pop(context);
              }, 
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
                    controller: twitterTextController,
                    cursorColor: ColorTheme.primary,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
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
                    controller: instaTextController,
                    cursorColor: ColorTheme.primary,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
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
                    controller: tiktokTextController,
                    cursorColor: ColorTheme.primary,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
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
                    controller: deviantArtTextController,
                    cursorColor: ColorTheme.primary,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0,),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        CustomIcons.link,
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
                    controller: websiteTextController,
                    cursorColor: ColorTheme.primary,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
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