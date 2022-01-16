import 'package:flutter/material.dart';

class RouteTransAnim {

  Route createRoute(double x, double y, dynamic page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(x, y);
        // var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        // var tween = Tween(begin: begin, end: end);
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        //var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}