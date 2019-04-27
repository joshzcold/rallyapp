import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:rallyapp/blocs/auth/auth_bloc.dart';
import 'package:rallyapp/blocs/auth/auth_state.dart';
import 'package:rallyapp/fireActions.dart';


FireActions fireActions = new FireActions();

changeUsername(context, closeThemeSelectorModal){
  var changeUserNameTextController = TextEditingController();
  ThemeBloc _themeBloc = BlocProvider.of<ThemeBloc>(context);
  ThemeLoaded theme = _themeBloc.currentState;
  return LayoutBuilder(builder: (context, constraints){
    var maxHeight = constraints.maxHeight;
    var maxWidth = constraints.maxWidth;
    var cardHeightMultiplier = 0.50;
    var cardWidthMultiplier = 0.80;

    if(maxWidth > maxHeight){
      cardHeightMultiplier = 0.80;
      cardWidthMultiplier = 0.50;
    }
    return InkWell(
      onTap: (){
        closeThemeSelectorModal();
      },
      child: Container(
        height: maxHeight,
        width: maxWidth,
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
        alignment: Alignment.center,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                new BoxShadow(
                  color: theme.theme['shadow'],
                  blurRadius: 5.0,
                  offset: Offset(0.0, 0.0),
                )
              ],
              color: theme.theme['background'],
            ),
            height: maxHeight * cardHeightMultiplier,
            width: maxWidth * cardWidthMultiplier,
            alignment: Alignment.center,
            child: Container(
              width: (maxWidth * cardWidthMultiplier) - 30,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Change Username', style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20,
                          color: theme.theme['textTitle']
                      ),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: theme.theme['border']),
                            color: theme.theme['card']
                        ),
                        width: (maxWidth * cardWidthMultiplier) * .80,
                        child: TextFormField(
                          autocorrect: false,
                          autovalidate: false,
                          style: TextStyle(color: theme.theme['text']),
                          cursorColor: theme.theme['textTitle'],
                          controller: changeUserNameTextController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: theme.theme['text']),
                            hintText: 'Username',
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            var un = changeUserNameTextController.text;
                            if(un != null && un != "" && un.length > 2){
                              saveNewUserName(un, context);
                            } else{
                              if(un == null){
                                _showDialog("Username is null","please enter in a valid username", context);
                              } else if (un == ""){
                                _showDialog("Username is blank","please enter in a valid username", context);
                              } else if(un.length <= 2){
                                _showDialog("Username is too short","please enter in a username larger than 2 characters", context);
                              }
                            }
                          },
                          padding: EdgeInsets.all(0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(color: theme.theme['colorPrimary'], borderRadius: BorderRadius.all(Radius.circular(8))),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.edit, color: Colors.white,),
                                      Container(width: 5,),
                                      Text('Save', style: TextStyle(color: Colors.white, fontSize: 15),),
                                    ],
                                  )
                              ),
                            ],
                          )
                      ),
                      FlatButton(
                          onPressed: () {
                            closeThemeSelectorModal();
                          },
                          padding: EdgeInsets.all(0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(color: theme.theme['colorSecondary'], borderRadius: BorderRadius.all(Radius.circular(8))),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.close, color: Colors.white,),
                                      Container(width: 5,),
                                      Text('Close', style: TextStyle(color: Colors.white, fontSize: 15),),
                                    ],
                                  )
                              ),
                            ],
                          )
                      ),
                    ],
                  )
                ],
              ),
            )
        ),
      ),
    );
  });
}

void saveNewUserName(username, context)async {
  await fireActions.newUserName(username, context);
  _showDialog("Changed Username", "New username is $username tell your friends so they aren't confused",context);
}

void _showDialog(title, content, context) {
  final _themeBloc = BlocProvider.of<ThemeBloc>(context);
  ThemeLoaded theme = _themeBloc.currentState;
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        backgroundColor: theme.theme['card'],
        title: new Text(title, style: TextStyle(color: theme.theme['textTitle']),),
        content: new Text(content,
          style: TextStyle(color: theme.theme['text']),),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}