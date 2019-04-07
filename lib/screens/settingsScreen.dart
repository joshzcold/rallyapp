import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/widgets/themeButton.dart';
import 'package:rallyapp/widgets/themeSelector.dart';
import 'package:rallyapp/blocs/app/theme.dart';

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
    ThemeBloc _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    return Scaffold(
      backgroundColor: theme.theme['background'],
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.theme['headerText'],), onPressed: (){Navigator.pop(context);}),
        title: Text('Settings', style: TextStyle(color: theme.theme['headerText']),), backgroundColor: theme.theme['header'],),
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
      themeSelectorModal = themeSelector(context, closeThemeSelectorModal);
    });
  }

  closeThemeSelectorModal(){
    setState(() {
      themeSelectorModal = Container();
    });
  }
}
