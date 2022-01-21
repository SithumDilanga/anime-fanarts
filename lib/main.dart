import 'package:anime_fanarts/auth/log_in.dart';
import 'package:anime_fanarts/auth/sign_up.dart';
import 'package:anime_fanarts/explore.dart';
import 'package:anime_fanarts/img_fullscreen.dart';
import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/profile/profile.dart';
import 'package:anime_fanarts/settings/settings.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Color(0xffF0F0F0),
    ),
    home: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  
  // const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffF0F0F0),
            elevation: 0,
            title: Text(
              'Anime fanarts',
              style: TextStyle(
                color: Colors.amber[600]
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
                        0.0, 1.0, 
                        Settings()
                      )
                    );

                }, 
              )
              // PopupMenuButton(
              //   icon: Icon(
              //     Icons.settings,
              //     color: Colors.black,
              //   ),
              //   onSelected: (selection) async {

              //     if(selection == 0) {

              //       Navigator.of(context).push(
              //         RouteTransAnim().createRoute(
              //           0.0, 1.0, 
              //           SignUp()
              //         )
              //       );

              //     } else if(selection == 1) {

              //       Navigator.of(context).push(
              //         RouteTransAnim().createRoute(
              //           0.0, 1.0, 
              //           Login()
              //         )
              //       );

              //     } 

              //   },
              //   itemBuilder: (context) => [
              //     PopupMenuItem(
              //       child: Text(
              //         'Sign up',
              //       ),
              //       value: 0
              //     ),
              //     PopupMenuItem(
              //       child: Text(
              //         'Login',
              //       ),
              //       value: 1
              //     )
              //   ]
              // )
            ],
            bottom: TabBar(
              indicatorColor: Colors.amber[600],
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Colors.amber[600]!
                ),
                insets: EdgeInsets.symmetric(
                  horizontal: 16.0
                )
              ),
              labelColor: Colors.amber[600],
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
  }
}

