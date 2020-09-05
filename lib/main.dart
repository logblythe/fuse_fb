import 'package:flutter/material.dart';
import 'package:fuse/core/services/navigation_service.dart';
import 'package:fuse/provider_setup.dart';
import 'package:fuse/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        navigatorKey: navigatorKey,
        home: Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
  }
}
