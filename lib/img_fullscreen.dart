import 'package:flutter/material.dart';

class ImgFullScreen extends StatelessWidget {
  const ImgFullScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: Hero(
          tag: 'fullscreenImg',
          child: InteractiveViewer(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://image.winudf.com/v2/image1/Y29tLkNyZWF0ZUlELkxldml3YWxscGFwZXJJRF9zY3JlZW5fMF8xNjI1NjkyNjI2XzA3MQ/screen-0.jpg?fakeurl=1&type=.jpg',
                  ),
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
        ), 
      ),
    );
  }
}