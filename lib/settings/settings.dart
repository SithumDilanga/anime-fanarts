import 'package:anime_fanarts/auth/log_in.dart';
import 'package:anime_fanarts/auth/sign_up.dart';
import 'package:anime_fanarts/profile/admin_add_new_art.dart';
import 'package:anime_fanarts/services/secure_storage.dart';
import 'package:anime_fanarts/settings/blocked_users.dart';
import 'package:anime_fanarts/settings/bug_report.dart';
import 'package:anime_fanarts/settings/contact_us.dart';
import 'package:anime_fanarts/settings/fcm_test.dart';
import 'package:anime_fanarts/settings/feedback.dart';
import 'package:anime_fanarts/settings/guidelines.dart';
import 'package:anime_fanarts/settings/privacy_policy.dart';
import 'package:anime_fanarts/settings/terms_of_use.dart';
import 'package:anime_fanarts/settings/what_is.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatefulWidget {



  const Settings({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  String? userId;

  void init() async {
    userId = await SecureStorage.getUserId();
  }

  @override
  void initState() {
    
    init();

    super.initState();
  }

  // logout confirmation Alert Dialog
  Future<void> _confirmLogoutAlert(BuildContext context) async {

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Are you sure you want to Logout?'),
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
                    'YES',
                    style: TextStyle(
                      color: ColorTheme.primary,
                      fontSize: 18.0
                    ),
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.blue[50]),
                  ),
                  onPressed: () async {

                      try {

                         await SecureStorage.deleteToken().whenComplete(() {

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            'Settings'
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
               CustomeListTile(
                Icons.info_outline_rounded,
                'What is Animizu?',
                () {
                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0, 
                      WhatIs()
                    )
                  );
                }
              ),
              CustomeListTile(
                Icons.feedback_outlined,
                'Give feedback',
                () {
                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0, 
                      GiveFeedback(
                        userId: userId
                      )
                    )
                  );
                }
              ),
              CustomeListTile(
                Icons.bug_report_outlined,
                'Bug report',
                () {
                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0, 
                      BugReport()
                    )
                  );
                }
              ),
              CustomeListTile(
                Icons.description_outlined,
                'Guidelines',
                () {
                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0, 
                      GuideLines()
                    )
                  );
                }
              ),
              CustomeListTile(
                Icons.assignment_outlined,
                'Terms of use',
                () {
                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0, 
                      TermsOfUse()
                    )
                  );
                }
              ),
              CustomeListTile(
                Icons.privacy_tip_outlined,
                'Privacy & policy',
                () {
                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0, 
                      PrivacyPolicy()
                    )
                  );
                }
              ),
              CustomeListTile(
                Icons.contact_support_outlined,
                'Contact us',
                () {
                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0, 
                      ContactUs()
                    )
                  );
                }
              ),
              CustomeListTile(
                Icons.block_rounded,
                'Blocked users',
                () {
                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0, 
                      BlockedUsers()
                    )
                  );
                }
              ),
              CustomeListTile(
                Icons.logout_rounded,
                'Logout',
                () async {

                  await _confirmLogoutAlert(context);

                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomeListTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final void Function() onTap;

  CustomeListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey))
      ),
      child: InkWell(
        splashColor: Colors.blue[100],
        borderRadius: BorderRadius.circular(3),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Icon(
                icon, 
                size: 22, 
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                child: Text(
                  text, 
                  style: TextStyle(
                    fontSize: 18, 
                    color: Colors.black, 
                    // shadows: [Shadow(blurRadius: 7.0, color: Colors.blueGrey[200]!, offset: Offset(1.0, 1.0),)]
                  ),
                ),
              )
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}