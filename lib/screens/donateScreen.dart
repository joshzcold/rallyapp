
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Donate extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    ThemeBloc _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: theme.theme['background'],
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.theme['headerText'],), onPressed: (){Navigator.pop(context);}),
          title: Text('Donate', style: TextStyle(color: theme.theme['headerText']),), backgroundColor: theme.theme['header'],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text('Thank you for clicking donate!', style: TextStyle(color: theme.theme['textTitle'], fontSize: 18),),
                    Container(height: 10,),
                    Card(
                        color: theme.theme['card'],
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            child:  Text('If you are here on purpose I really want to thank you for considering supporting this application.'
                                ' When creating rally we (the developers) wanted to keep rally as free as possible... meaning no ads or'
                                ' important features behind a pay wall. I Just want to tell that your donation will only be used to support the operating '
                                ' costs of the application and not be a paycheck for the developers.', style:
                            TextStyle(color: theme.theme['text']),)
                        )
                    )
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text('Here are the operting costs your donation will help support, '
                        'Overall the costs are pretty low, but anything we recieve extra will be saved and used as needed',
                      style: TextStyle(color: theme.theme['textTitle']),),

                    Container(height: 10,),
                    Row(
                      children: <Widget>[
                        Icon(Icons.arrow_right, color: theme.theme['colorPrimary'],),
                        Container(width: 10,),
                        Text('Database and storage quotas',style: TextStyle(color: theme.theme['textTitle']),)
                      ],
                    ),

                    Container(height: 5,),
                    Row(
                      children: <Widget>[
                        Icon(Icons.arrow_right, color: theme.theme['colorPrimary'],),
                        Container(width: 10,),
                        Text('Apple appstore developer license fees',style: TextStyle(color: theme.theme['textTitle']),)
                      ],
                    ),

                    Container(height: 5,),
                    Row(
                      children: <Widget>[
                        Icon(Icons.arrow_right, color: theme.theme['colorPrimary'],),
                        Container(width: 10,),
                        Text('Yearly domain costs',style: TextStyle(color: theme.theme['textTitle']),)
                      ],
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                      onPressed: () async {
                        const url = 'https://rallyup.app/donate';
                        if (await canLaunch(url)) {
                        await launch(url);
                        } else {
                        throw 'Could not launch $url';
                        }
                      },
                      padding: EdgeInsets.all(0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              decoration: BoxDecoration(color: theme.theme['colorSecondary'], borderRadius: BorderRadius.all(Radius.circular(8))),
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  Text('Donate', style: TextStyle(color: Colors.white, fontSize: 15),),
                                  Container(width: 5,),
                                  Icon(Icons.favorite, color: theme.theme['colorPrimary'],),
                                ],
                              )
                          ),
                        ],
                      )
                  ),
                ],
              ),
              Container(height: 30,)
            ],
          )
        )
    );
  }

}