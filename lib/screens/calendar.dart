import 'package:flutter/material.dart';

class Calendar extends StatefulWidget{
  final title = "Rally";
  @override
  State<StatefulWidget> createState() => CalendarState();
}

class CalendarState extends State<Calendar>{

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