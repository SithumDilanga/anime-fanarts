import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({ Key? key }) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {

  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings'
        ),
        backgroundColor: ColorTheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded
          ),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'When someone followed you',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal
                  ),
                ),
                Switch(
                  value: switchValue, 
                  onChanged: (value) {
                    setState(() {
                      switchValue = !switchValue;
                    });
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}