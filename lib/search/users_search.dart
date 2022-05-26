import 'package:anime_fanarts/settings/contact_us.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class UsersSearch extends StatefulWidget {
  const UsersSearch({ Key? key }) : super(key: key);

  @override
  State<UsersSearch> createState() => _UsersSearchState();
}

class _UsersSearchState extends State<UsersSearch> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffF0F0F0),
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: 15,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 100,
                child: Text(
                  'Papadamn Noire',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    // opacity: 0.5,
                    colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.dstATop
                    ),
                    image: NetworkImage(
                      'https://data.whicdn.com/images/323989653/original.jpg'
                    ),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              SizedBox(height: 8.0,)
            ],
          );
          // return Column(
          //   children: [
          //     GestureDetector(
          //       child: ListTile(
          //         leading: CircleAvatar(
          //           radius: 24,
          //           backgroundColor: Colors.blueGrey[700],
          //           backgroundImage: ExtendedNetworkImageProvider(
          //             'https://i.pinimg.com/736x/67/d6/af/67d6af844900ef007771d41daf9df35c.jpg',
          //             // cache: true,
          //           ),
          //         ),
          //         title: Text(
          //           'Levi Ackerman',
          //           style: TextStyle(
          //             fontSize: 18
          //           ),
          //         ),
          //         subtitle: Text(
          //           '@username'
          //         ),
          //       ),
          //       onTap: () {

          //         Navigator.of(context).push(
          //           RouteTransAnim().createRoute(
          //             1.0, 0.0, 
          //             ContactUs()
          //           )
          //         );

          //       },
          //     ),
          //     SizedBox(height: 12.0,)
          //   ],
          // );
        }
      ),
    );
  }
}