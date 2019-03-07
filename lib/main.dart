import 'package:flutter/material.dart';
import 'package:rallyapp/model/authModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rallyapp/screens/login.dart';
import 'package:rallyapp/screens/calendar.dart';
import 'package:rallyapp/screens/settings.dart';

void main() {
  // Now we're ready to run the Flutter UI.
  runApp(
    new Rally()
  );
}

class Rally extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        textTheme: TextTheme(
          display4: TextStyle(
            fontFamily: 'Corben',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/calendar': (context) => Calendar(),
        '/settings': (context) => Settings(),
      },
    );
  }
}











