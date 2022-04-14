import 'package:anime_fanarts/models/quote.dart';
import 'package:anime_fanarts/services/fcm.dart';
import 'package:flutter/material.dart';

class FCMTesting extends StatefulWidget {
  const FCMTesting({ Key? key }) : super(key: key);

  @override
  State<FCMTesting> createState() => _FCMTestingState();
}

class _FCMTestingState extends State<FCMTesting> {

  FirebaseCloudMessaging _fcm = FirebaseCloudMessaging();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: ElevatedButton(
          child: Text(
            'SEND'
          ),
          onPressed: () {

            _fcm.sendDailyQuote(
              dailyQuote: Quote(
                title: 'Test title',
                quote: 'Test notification'
              ) 
            );

          }, 
        ),
      ),
    );
  }
}