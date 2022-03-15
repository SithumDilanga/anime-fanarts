import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhatIs extends StatelessWidget {
  const WhatIs({ Key? key }) : super(key: key);

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
          'What is Animizu?'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.5,
                      color: ColorTheme.primary
                    )
                  )
                ),
                child: Text(
                  'What is Animizu?',
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                  ),
                ),
              ),
              SizedBox(height: 16,),
                RichText(
                  text: TextSpan(
                    text: "Animizu is an artwork platform specified for Anime & Manga. Artists can showcase their artworks and manage their own portfolio. Fans can find fanarts of their favorite Anime/Manga character and so many other original artworks as well. Fans can also share their Anime/Manga cosplays. You don’t have to be a professional artist. Even if your skills are in the initial stage feel free to share and ask for suggestions from others. Don’t forget to appreciate others' artworks as well.",
                    style: GoogleFonts.share(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      height: 1.2
                    ),
                    children: [
                      // TextSpan(
                      //   text: 'rules.',
                      //   style: GoogleFonts.share(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w600,
                      //     color: Color(0xffFFA500),
                      //     decoration: TextDecoration.underline
                      //   ),
                      //   recognizer: TapGestureRecognizer()..onTap = () {
      
                      //   }
                      // )
                    ]
                  ),
                ),
                SizedBox(height: 12.0,),
              // Text(
              //   'Mauris semper eros a placerat pharetra. Nam vitae urna et mauris tristique mollis in nec dui. Sed congue purus non tincidunt imperdiet. Aenean rutrum tincidunt sapien',
              //   style: GoogleFonts.share(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w600,
              //     color: Colors.grey[800],
              //     height: 1.2
              //   ),
              // ),
              SizedBox(height: 16.0,),
              Image.network(
                'https://cdn140.picsart.com/315531393000211.png'
              )
            ],
          ),
        ),
      ),
    );
  }
}