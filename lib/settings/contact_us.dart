import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: ColorTheme.primary,
        title: Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }, 
        ),
      ),
      body: Column(
        children: [
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0
              ),
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: 'Feel free to contact us at gritie.contact@gmail.com',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.3
                ),
                linkStyle: TextStyle(
                  color: ColorTheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ),
          SizedBox(height: 64.0,),
          Image.asset(
            'assets/images/contact-us-bg.png',
            height: 300,
          ),
        ],
      )
    );
  }
}

class TextRow extends StatelessWidget {
  const TextRow({ Key? key, this.contactName, this.contactValue }) : super(key: key);

  final String? contactName, contactValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          contactName!,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          )
        ),
        SizedBox(width: 48.0),
        Expanded(
          child: Text(
            contactValue!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        )
      ]
    );
  }
}