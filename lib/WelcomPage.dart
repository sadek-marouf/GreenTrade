import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomPage extends StatelessWidget {
  const WelcomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [PageView(
          children: [
            Image.asset("images/welcom1.jpg"),
            Image.asset("images/welcom1.jpg"),
          ],
        )],
      )

    );
  }
}
