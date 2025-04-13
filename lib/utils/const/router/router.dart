import 'package:flutter/material.dart';

Route buildRoute(
  Widget page,
  RouteSettings settings, {
  RouteAnimationType type = RouteAnimationType.slide,
}) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      switch (type) {
        case RouteAnimationType.fade:
          return FadeTransition(opacity: animation, child: child);
        case RouteAnimationType.slide:
          return SlideTransition(
            position: Tween(begin: Offset(1, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          );
        case RouteAnimationType.scale:
          return ScaleTransition(scale: animation, child: child);
        default:
          return child;
      }
    },
  );
}

enum RouteAnimationType { fade, slide, scale, none }
