import 'package:flutter/material.dart';
import 'package:fuse/ui/screens/add_post_screen.dart';
import 'package:fuse/ui/screens/edit_post_screen.dart';
import 'package:fuse/ui/screens/home_screen.dart';

class RoutePaths {
  static const String HOME = "/home";
  static const String ADD_POST = "/add-post";
  static const String EDIT_POST = "/edit-post";
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.HOME:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RoutePaths.ADD_POST:
        return MaterialPageRoute(builder: (_) => AddPostScreen());
      case RoutePaths.EDIT_POST:
        return MaterialPageRoute(builder: (_) => EditPostScreen());
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
