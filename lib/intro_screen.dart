import 'dart:ui';
import 'package:anime_fanarts/auth/sign_up.dart';
import 'package:anime_fanarts/explore.dart';
import 'package:anime_fanarts/main.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
// import 'package:motivational_quotes/boost_yourself/shared_pref.dart';
// import 'package:motivational_quotes/home/home.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({ Key? key }) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

void goHomepage(context) async {
   Navigator.of(context).pushAndRemoveUntil(
     RouteTransAnim().createRoute(1.0, 0.0, SignUp()),
   (Route<dynamic> route) => false);
  //Navigate to home page and remove the intro screen history
  //so that "Back" button wont work.

  //     MaterialPageRoute(builder: (context){ 
  //       //  return Home();
  //       return RouteTransAnim().createRoute(-1.0, 0.0, BoostYourself()); 
  //     }
  // ),

  await SharedPref.setIsWelcomed(true);
}

class _IntroScreenState extends State<IntroScreen> {

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: ColorTheme.primary,
      pages: [
        PageViewModel(
          title: "Welcome to Animizu",
          body: "It's all about Anime & Manga artworks",
          image: Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 150,
              width: 150,
            )
          ),
          decoration: PageDecoration(
            // pageColor: Colors.blueGrey,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            bodyTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18
            ),
            boxDecoration: BoxDecoration(
              color: ColorTheme.primary
            //   gradient: LinearGradient(
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomLeft,
            //   stops: [0.1, 0.5, 0.7, 0.9],
            //   colors: [
            //     Color(0xFF4C9CD6),
            //     Color(0xFF338DD1),
            //     Color(0xFF1A7FCB),
            //     ColorTheme.primary,
            //   ],
            // ),
          )
          ),
        ),
        PageViewModel(
          title: "For Artists",
          body: "You can showcase your artworks and manage your own portfolio",
          // image: Center(
          //   child: Image.asset(
          //     'assets/images/paint-brush.png',
          //     height: 150,
          //     width: 150,
          //   )
          // ),
          image: Center(
            child: Icon(
              Icons.brush_rounded,
              color: Colors.white,
              size: 96,
            )
            // child: Image.asset(
            //   'assets/images/Gritie4.png' 
            // ),
            // child: Container(
            //   padding: EdgeInsets.all(8),
            //   width: 150,
            //   height: 150,
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       width: 2, 
            //       color: Colors.white,
            //     ),
            //     // shape: BoxShape.circle,
            //     borderRadius: BorderRadius.all(
            //       Radius.circular(400)
            //     ),
            //   ),
            //   child: Center(
            //     child: Text(
            //       'Gritie',
            //       style: GoogleFonts.alegreyaSans(
            //         color: Colors.white,
            //         fontSize: 48,
            //         fontWeight: FontWeight.bold
            //       ),
            //     ),
            //   ),
            // ),
          ),
          decoration: PageDecoration(
            // pageColor: Colors.blueGrey,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            bodyTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18
            ),
            boxDecoration: BoxDecoration(
              color: ColorTheme.primary,
          )
          ),
        ),
        PageViewModel(
          title: "For Fans",
          body: "Find fanarts of your favorite Anime/Manga characters and so many other original arts",
          image: Center(
            child: Icon(
              Icons.remember_me_rounded,
              color: Colors.white,
              size: 96,
            )
          ),
          decoration: PageDecoration(
            // pageColor: Colors.blueGrey,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            bodyTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18
            ),
            boxDecoration: BoxDecoration(
              color: ColorTheme.primary
          )
          ),
        ),
        PageViewModel(
          title: "Cheers 🥂",
          body: "Let's enjoy the world of Anime & Manga artworks!",
          image: Center(
            child: Center(
              child: Text(
                'Animizu',
                style: TextStyle(
                  fontFamily: 'Forte',
                  color: Colors.white,
                  fontSize: 48,
                  letterSpacing: 1
                ),
              ),
            ),
          ),
          footer: ElevatedButton(
            
            onPressed: () async {
              
              goHomepage(context);
              
            },
            child: const Text(
              "Let's Go !",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF80B8E2),
              textStyle: TextStyle(
                
              )
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            bodyTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18
            ),
            boxDecoration: BoxDecoration(
              color: ColorTheme.primary
          )
          ),
        )
      ], 
      onDone: () => goHomepage(context), 
      onSkip: () => goHomepage(context),
      showSkipButton: true,
      skip: const Text(
        'Skip',
        style: TextStyle(
          color: Colors.white
        ),
      ),
      next: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white,
      ),
      done: const Text(
        'Done', 
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white
        )
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Color(0xFF80B8E2),
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0)
        )
      ),
    );
  }
}