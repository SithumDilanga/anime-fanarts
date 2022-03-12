import 'dart:async';
import 'package:anime_fanarts/auth/sign_up.dart';
import 'package:anime_fanarts/explore.dart';
import 'package:anime_fanarts/models/new_post_refresher.dart';
import 'package:anime_fanarts/models/profile_user.dart';
import 'package:anime_fanarts/profile/profile.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/settings/settings.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPref.init();

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Set default home.
  Widget _defaultHome = new SignUp();

  // final bearerToken = await SecureStorage.getToken();
  const _storage = FlutterSecureStorage();

  try {
    final bearerToken = await SecureStorage.getToken();
    
    if(bearerToken != null) {
      _defaultHome = new MyApp();
    }
  // ignore: nullable_type_in_catch_clause
  } on PlatformException catch (e) {
    await _storage.deleteAll();
  }

  // if(bearerToken != null) {
  //   _defaultHome = new MyApp();
  // }

  runZonedGuarded<Future<void>>(() async {
    runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileUser>(create: (_) => ProfileUser()),
        ChangeNotifierProvider<NewPostFresher>(create: (_) => NewPostFresher(
          isPostAdded: false,
          isPostDeleted: false
        )),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffF0F0F0),
        ),
        home: _defaultHome //MyApp()
      ),
    ));
    }, (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });
  
}

class MyApp extends StatefulWidget {
  

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffF0F0F0),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'Animizu',
              style: GoogleFonts.signikaNegative(
                textStyle: TextStyle(
                  color: ColorTheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 1
                ),
              ),

            ),
            actions: <Widget> [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                onPressed: () {
    
                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, -1.0, 
                      Settings()
                    )
                  );
    
                }, 
              )
            ],
            bottom: TabBar(
              indicatorColor: ColorTheme.primary,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 2.0,
                  color: ColorTheme.primary
                ),
                insets: EdgeInsets.symmetric(
                  horizontal: 16.0
                )
              ),
              labelColor: ColorTheme.primary,
              unselectedLabelColor: Colors.black54,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.explore,
                        size: 24,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 24,
                      ),
                      SizedBox(width: 8.0,),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
              ]
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: TabBarView(
              children: [
                Explore(),
                Profile()
              ]
            ),
          ),
        ),
      );
    // }

    // return LoadingAnimation();

  }
}

