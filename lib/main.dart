import 'package:feedtest/screens/PreHome.dart';
import 'package:flutter/material.dart';
import 'package:feedtest/screens/HomeScreen.dart';
import 'package:feedtest/screens/Profile.dart';


// Navigator page for main files PreHome, HomeScreen using a static const id
// in each file


void main() {
  runApp(Feed());
}

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: PreHome.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        Profile.id: (context) => Profile(user: "Jude"),
        PreHome.id: (context) => PreHome(),
      }
    );
  }
}