import 'package:anime_fanarts/auth/sign_up.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
                Icons.feedback_outlined,
                'Give feedback',
                () {
                  // Navigator.of(context).push(
                  //   RouteTransAnim().createRoute(
                  //     -1.0, 0.0, 
                  //     ContactUs()
                  //   )
                  // );
                }
              ),
              CustomeListTile(
                Icons.bug_report_outlined,
                'Bug report',
                () {
                  // Navigator.of(context).push(
                  //   RouteTransAnim().createRoute(
                  //     -1.0, 0.0, 
                  //     ContactUs()
                  //   )
                  // );
                }
              ),
              CustomeListTile(
                Icons.privacy_tip_outlined,
                'Privacy & policy',
                () {
                  // Navigator.of(context).push(
                  //   RouteTransAnim().createRoute(
                  //     -1.0, 0.0, 
                  //     ContactUs()
                  //   )
                  // );
                }
              ),
              CustomeListTile(
                Icons.info_outline_rounded,
                'About us',
                () {
                  // Navigator.of(context).push(
                  //   RouteTransAnim().createRoute(
                  //     -1.0, 0.0, 
                  //     ContactUs()
                  //   )
                  // );
                }
              ),
              CustomeListTile(
                Icons.contact_support_outlined,
                'Contact us',
                () {
                  // Navigator.of(context).push(
                  //   RouteTransAnim().createRoute(
                  //     -1.0, 0.0, 
                  //     ContactUs()
                  //   )
                  // );
                }
              ),
              CustomeListTile(
                Icons.login_rounded,
                'Sign up',
                () {
                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      -1.0, 0.0, 
                      SignUp()
                    )
                  );
                }
              ),
              CustomeListTile(
                Icons.logout_rounded,
                'Logout',
                () {
                  // Navigator.of(context).push(
                  //   RouteTransAnim().createRoute(
                  //     -1.0, 0.0, 
                  //     ContactUs()
                  //   )
                  // );
                }
              ),
              // ElevatedButton(
              //   child: Text(
              //     'Sign up'
              //   ),
              //   onPressed: () {

              //     Navigator.of(context).push(
              //       RouteTransAnim().createRoute(
              //         0.0, 1.0, 
              //         SignUp()
              //       )
              //     );

              //   }, 
              // )
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