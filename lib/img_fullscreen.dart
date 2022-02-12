import 'package:anime_fanarts/services/download_share.dart';
import 'package:anime_fanarts/services/permissions_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImgFullScreen extends StatelessWidget {

  //TODO: edit these parameter properly
  
  final String? imgLink;
  final int selectedimageIndex;
  final List? imageList;
  final String? username;

  ImgFullScreen({ Key? key, required this.selectedimageIndex, this.imageList, this.imgLink, this.username }) : super(key: key);

  // static const IMGURL = 'http://10.0.2.2:3000/img/users/';
  static const IMGURL = 'https://vast-cliffs-19346.herokuapp.com/img/users/';
  DownloadShare _downloadShare = DownloadShare();

  // --- asking user permission ---
   askPermission(){
    PermissionsService().requestStoragePermission(
      onPermissionDenied: () {
        print('Permission has been denied');
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
            InteractiveViewer(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      '$IMGURL${imgLink}', // '$imgLink',
                    ),
                    fit: BoxFit.contain,
                  )
                ),
              ),
            ),
            // Hero(
            //   tag: 'fullscreenImg',
            //   child: InteractiveViewer(
            //     child: Container(
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //           image: NetworkImage(
            //             '${imageList![imageIndex]}' // '$imgLink',
            //           ),
            //           fit: BoxFit.contain
            //         )
            //       ),
            //     ),
            //   ),
            // ),
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
                            '$IMGURL$imgLink',
                            username
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
                            '$IMGURL$imgLink'
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

// Hero(
//               tag: 'fullscreenImg',
//               child: CarouselSlider(
//                 options: CarouselOptions(
//                   height: double.infinity,
//                   autoPlay: false,
//                   viewportFraction: 1,
//                   enableInfiniteScroll: false, 
//                   initialPage: selectedimageIndex,
//                 ),
//                 items: imageList!.map((image) {
//                   return Builder(
//                     builder: (BuildContext context) {
//                       return InteractiveViewer( 
//                         child: Container(
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: NetworkImage(
//                                 '${image}', // '$imgLink',
//                               ),
//                               fit: BoxFit.contain,
//                             )
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//               ),
//             ),