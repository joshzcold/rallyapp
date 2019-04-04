import 'package:flutter/material.dart';
import 'package:rallyapp/widgets/themeButton.dart';

Widget themeSelectorModal;

class Settings extends StatefulWidget{
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings>{

  @override
  void initState(){
    super.initState();
    themeSelectorModal = Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),),
      body: LayoutBuilder(builder: (context, constraints){
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  themeButton(context, constraints, getThemeSelectorModal)
                ],
              ),
              AnimatedSwitcher(
                // the duration can be adjusted to expand the friend events
                // faster or slower.
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double>animation) {
                    return FadeTransition(opacity: animation,
                      child: child,
                    );
                  },
                  child: themeSelectorModal
              ),
            ],
          ),
        );
      })
    );
  }

  getThemeSelectorModal() {
    setState(() {
      themeSelectorModal = LayoutBuilder(builder: (context, constraints){
        var maxHeight = constraints.maxHeight;
        var maxWidth = constraints.maxWidth;
        var cardHeightMultiplier = 0.35;
        var cardWidthMultiplier = 0.95;

        if(maxWidth > maxHeight){
          cardHeightMultiplier = 0.80;
          cardWidthMultiplier = 0.70;
        }
        return InkWell(
          onTap: (){
            setState(() {
              themeSelectorModal = Container();
            });
          },
          child: Container(
            height: maxHeight,
            width: maxWidth,
            decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
            alignment: Alignment.center,
            child: Container(
                height: 300,
                width: maxWidth * cardWidthMultiplier,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                    ],
                  ),
                )
            ),
          ),
        );
      });
    });
  }
}
