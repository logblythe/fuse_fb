import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: Colors.black12,
        child: Image.asset(
          'assets/images/placeholder.png',
          height: 60,
          width: 60,
        ),
      ),
    );
  }
}
