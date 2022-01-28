import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImgFullScreen extends StatelessWidget {

  //TODO: edit these parameter properly
  
  final String? imgLink;
  final int selectedimageIndex;
  final List? imageList;

  const ImgFullScreen({ Key? key, required this.selectedimageIndex, this.imageList, this.imgLink }) : super(key: key);

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
                      '$imgLink', // '$imgLink',
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
                  child: IconButton(
                    icon: Icon(
                      Icons.share_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      
                    }, 
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