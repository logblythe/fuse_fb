import 'package:flutter/material.dart';
import 'package:fuse/ui/screens/add_post_screen.dart';
import 'package:fuse/ui/screens/home_screen.dart';

class RoutePaths {
  static const String HOME = "/home";
  static const String POST_DETAILS = "/post-details";
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.HOME:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RoutePaths.POST_DETAILS:
        return MaterialPageRoute(builder: (_) => AddPostScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
