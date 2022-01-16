import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.brown[100],
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.amber,
          size: 50.0,
        )
      ),
    );
  }
}