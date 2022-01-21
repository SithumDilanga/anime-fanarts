import 'package:anime_fanarts/auth/sign_up.dart';
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
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Give feedback'
              ),
              ElevatedButton(
                child: Text(
                  'Sign up'
                ),
                onPressed: () {

                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      0.0, 1.0, 
                      SignUp()
                    )
                  );

                }, 
              )
            ],
          ),
        ),
      ),
    );
  }
}