import 'dart:async';
import 'dart:io';
import 'package:anime_fanarts/auth/sign_up.dart';
import 'package:anime_fanarts/explore.dart';
import 'package:anime_fanarts/intro_screen.dart';
import 'package:anime_fanarts/models/profile_user.dart';
import 'package:anime_fanarts/models/reacted_posts.dart';
import 'package:anime_fanarts/profile/profile.dart';
import 'package:anime_fanarts/profile/users_profile.dart';
import 'package:anime_fanarts/search/search-2.dart';
import 'package:anime_fanarts/search/search.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/settings/settings.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  bool isWelcomed = SharedPref.getIsWelcomed();

  try {
    final bearerToken = await SecureStorage.getToken();
    
    if(bearerToken != null) {
      _defaultHome = new MyApp(selectedPage: 0,);
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
        // ChangeNotifierProvider<NewPostFresher>(create: (_) => NewPostFresher(
        //   isPostAdded: false,
        //   isPostDeleted: false
        // )),
        ChangeNotifierProvider<ReactedPosts>(create: (_) => ReactedPosts(
          reactedPosts: [], 
          removedReactionList: {}
        )),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffF0F0F0),
        ),
        home: isWelcomed ? _defaultHome : IntroScreen() //MyApp()
      ),
    ));
    }, (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });
  
}

class MyApp extends StatefulWidget {

  final int selectedPage;

  MyApp({Key? key, required this.selectedPage}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        initialIndex: widget.selectedPage,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffF0F0F0),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: GestureDetector(
              child: Text(
                'Animizu',
                style: TextStyle(
                  fontFamily: 'Forte',
                  color: ColorTheme.primary,
                  fontSize: 28,
                  letterSpacing: 1
                ),
              ),
              onTap: () {

                Navigator.of(context).push(
                  RouteTransAnim().createRoute(
                    1.0, 0.0, 
                    UsersProfile(
                      name: 'Animizu Official', 
                      userId: '6242217a06e7ba94057a6212'
                    )
                  )
                );

              },
            ),
            actions: <Widget> [
              IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ),
                onPressed: () {

                  showSearch(
                    context: context, 
                    delegate: MySearchDelegate(),
                  );
    
                  // Navigator.of(context).push(
                  //   RouteTransAnim().createRoute(
                  //     1.0, -1.0, 
                  //     // SearchListExample()
                  //     Search2()
                  //   )
                  // );
    
                }, 
              ),
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
              ),
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

