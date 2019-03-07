import 'package:flutter/material.dart';

class Settings extends StatefulWidget{
  final title = "Rally";
  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}