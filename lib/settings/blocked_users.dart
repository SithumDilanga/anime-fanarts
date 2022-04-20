import 'package:anime_fanarts/main.dart';
import 'package:anime_fanarts/services/block_user_req.dart';
import 'package:anime_fanarts/services/shared_pref.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:flutter/material.dart';

class BlockedUsers extends StatelessWidget {
  
  BlockedUsers({ Key? key }) : super(key: key);
  
  BlockUserReq _blockUserReq = BlockUserReq();

  // unblock user confirmation Alert Dialog
  Future<void> _unblockUserConfirmAlert(BuildContext context, String unblockedUserId) async {

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Are you sure you want to unblock this user ?"),
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
                  onPressed: () {

                    SharedPref.setUnblockedUser(unblockedUserId).then((value) {

                    _blockUserReq.unblockUser(unblockedUserId).whenComplete(() {

                      Navigator.of(context).pushAndRemoveUntil(
                       MaterialPageRoute(
                           builder: (context) => MyApp(selectedPage: 0)),
                           (route) => false
                      );

                    });

                    });

                    // print('unblockedUser ${SharedPref.getBlockedUserIdsList()}');

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
          'Blocked users'
        ),
      ),
      body: FutureBuilder(
        future: _blockUserReq.getBlockedUsers(
          isWhenLogin: false
        ),
        builder: (context, AsyncSnapshot snapshot) {


          if(snapshot.hasData) {

          // print('blockedusers ${snapshot.data['data']['blocklist']}');

            if(snapshot.data['data']['blocklist'].isEmpty) {
              return Center(
                child: Text(
                  'No blocked users',
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data['data']['blocklist'].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorTheme.primary,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: ListTile(
                      title: Text(
                        '${snapshot.data['data']['blocklist'][index]['name']}',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white
                        ),
                        onPressed: () {
                          _unblockUserConfirmAlert(
                            context, 
                            snapshot.data['data']['blocklist'][index]['blockedUser']
                          );
                        }, 
                      )
                    ),
                  ),
                );
              }
            );

          }

          return Padding(
            padding: const EdgeInsets.only(top: 128),
            child: LoadingAnimation(),
          );
          
        }
      )
    );
  }
}