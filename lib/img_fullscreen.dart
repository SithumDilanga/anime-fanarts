import 'package:anime_fanarts/services/download_share.dart';
import 'package:anime_fanarts/services/permissions_service.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImgFullScreen extends StatefulWidget {
  
  final String? imgLink;
  final int selectedimageIndex;
  final List? imageList;
  final String? name;
  final bool isUserPost;

  ImgFullScreen({ Key? key, required this.selectedimageIndex, this.imageList, this.imgLink, required this.name, required this.isUserPost }) : super(key: key);

  @override
  State<ImgFullScreen> createState() => _ImgFullScreenState();
}

class _ImgFullScreenState extends State<ImgFullScreen> {
  DownloadShare _downloadShare = DownloadShare();

  late PageController controller;
  int corousalImageIndex = 0;
  
  @override
  void initState() {
    super.initState();

    controller = PageController(
      initialPage: widget.selectedimageIndex
    );

    // setting initial selected image index
    corousalImageIndex = widget.selectedimageIndex;

  }

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

    print('images ${widget.imgLink}');

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: Stack(
          children: [
            Hero(
              tag: '${widget.isUserPost.toString() + widget.imgLink.toString()}',
              // child: InteractiveViewer(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: ExtendedNetworkImageProvider(
              //           '$imgLink', // '$imgLink',
              //           cache: true,
              //         ),
              //         fit: BoxFit.contain,
              //       )
              //     ),
              //   ),
              // ),
              child: PageView(
                controller: controller,
                children: [
                  for(String imageLink in widget.imageList!)
                    Center(
                      child: ExtendedImage.network(
                        imageLink,//'$imgLink',
                        fit: BoxFit.contain,
                        mode: ExtendedImageMode.gesture,
                          initGestureConfigHandler: (state) {
                            return GestureConfig(
                              minScale: 0.9,
                              animationMinScale: 0.7,
                              maxScale: 3.0,
                              animationMaxScale: 3.5,
                              speed: 1.0,
                              inertialSpeed: 100.0,
                              initialScale: 1.0,
                              inPageView: false,
                              initialAlignment: InitialAlignment.center,
                            );
                          },
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return CircularProgressIndicator(
                                backgroundColor: ColorTheme.primary,
                              );
                              
                              case LoadState.completed:
                                return null;
                            
                              case LoadState.failed:
                               return null;
                          }
                        },
                      ),
                    ),
                ],
                onPageChanged: (index) {
                  print('corousalImageIndex ${corousalImageIndex}');
                  setState(() {
                    corousalImageIndex = index;
                  });
                },
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
                            '${widget.imageList![corousalImageIndex]}',
                            widget.name
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
                            '${widget.imageList![corousalImageIndex]}'
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
