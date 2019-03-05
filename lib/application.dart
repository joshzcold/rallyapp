import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> getFireBaseUser() async {
  final FirebaseUser user = await auth.currentUser();
  print('Current User $user');
}

void main() {
  getFireBaseUser();
  runApp(
    MaterialApp(
      title: 'Rally',
      home: ContentPage(),
    ),
  );
}

class ContentPage extends StatefulWidget {
  final String title = 'Rally';
  @override
  State<StatefulWidget> createState() => ContentPageState();
}

class ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Builder(builder: (BuildContext context) {
          return
              Text('Hello!');
        })
    );
  }
}
