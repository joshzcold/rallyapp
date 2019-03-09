import 'package:flutter/material.dart';
import 'package:rallyapp/screens/login.dart';
import 'package:rallyapp/screens/settings.dart';
import 'package:rallyapp/screens/mainScreen.dart';


void main() {
runApp(Rally());
}

class Rally extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rally',
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/main': (context) => MainScreen(),
        '/settings': (context) => Settings(),
      },
    );
  }
}











