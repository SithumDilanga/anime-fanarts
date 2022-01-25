import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
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
          'What is Anime Fanarts?'
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
                  'What is Anime Fanarts?',
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
                    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc tempus tortor nec odio euismod placerat. Curabitur nec lectus a tellus sollicitudin fermentum. Praesent malesuada libero porta erat convallis pulvinar. Duis vitae sodales nulla',
                    style: GoogleFonts.share(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      height: 1.2
                    ),
                    children: [
                      TextSpan(
                        text: 'rules.',
                        style: GoogleFonts.share(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffFFA500),
                          decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
      
                          // Navigator.of(context).push(
                          //   RouteTransAnim().createRoute(
                          //     0.0, 1.0, 
                          //     RulesGritieShare()
                          //   )
                          // );
      
                        }
                      )
                    ]
                  ),
                ),
                SizedBox(height: 16.0,),
              Text(
                'Mauris semper eros a placerat pharetra. Nam vitae urna et mauris tristique mollis in nec dui. Sed congue purus non tincidunt imperdiet. Aenean rutrum tincidunt sapien',
                style: GoogleFonts.share(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                  height: 1.2
                ),
              ),
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