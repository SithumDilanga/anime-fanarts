import 'package:flutter/material.dart';

class ImgFullScreen extends StatelessWidget {

  final String? imgLink;

  const ImgFullScreen({ Key? key, required this.imgLink }) : super(key: key);

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
              tag: 'fullscreenImg',
              child: InteractiveViewer(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        '$imgLink',
                      ),
                      fit: BoxFit.contain
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