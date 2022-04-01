import 'package:anime_fanarts/services/download_share.dart';
import 'package:anime_fanarts/services/permissions_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImgFullScreen extends StatelessWidget {
  
  final String? imgLink;
  final int selectedimageIndex;
  final List? imageList;
  final String? name;
  final bool isUserPost;

  ImgFullScreen({ Key? key, required this.selectedimageIndex, this.imageList, this.imgLink, required this.name, required this.isUserPost }) : super(key: key);

  DownloadShare _downloadShare = DownloadShare();

  // --- asking user permission ---
   askPermission(){
    PermissionsService().requestStoragePermission(
      onPermissionDenied: () {
        Fluttertoast.showToast(
         msg: 'Permission denied! cannot download image',
         toastLength: Toast.LENGTH_SHORT,
         backgroundColor: Colors.grey[800],
     );
 
    });
   }
  // --- End asking user permission ---

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: Stack(
          children: [
            Hero(
              tag: '${isUserPost.toString() + imgLink.toString()}',
              child: InteractiveViewer(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExtendedNetworkImageProvider(
                        '$imgLink', // '$imgLink',
                        cache: true
                      ),
                      fit: BoxFit.contain,
                    )
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.share_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {

                          _downloadShare.shareImage(
                            '$imgLink',
                            name
                          );
                          
                        }, 
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {

                          askPermission();
                      
                          _downloadShare.downloadImage(
                            '$imgLink'
                          );
                          
                        }, 
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ), 
      ),
    );
  }
}
