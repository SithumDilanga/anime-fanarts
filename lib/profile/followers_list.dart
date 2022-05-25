import 'package:anime_fanarts/utils/colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class FollowersList extends StatefulWidget {
  const FollowersList({ Key? key }) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Followed Users'
        ),
      ),
      body: ListView.builder(
        itemCount: 15,
        padding: const EdgeInsets.symmetric(
          vertical: 16.0
        ),
        itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueGrey[700],
                    backgroundImage: ExtendedNetworkImageProvider(
                      'https://i.pinimg.com/736x/67/d6/af/67d6af844900ef007771d41daf9df35c.jpg',
                      // cache: true,
                    ),
                  ),
                  title: Text(
                    'Levi Ackerman',
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                ),
                SizedBox(height: 12.0,)
              ],
            );
          }
      ),
    );
  }
}