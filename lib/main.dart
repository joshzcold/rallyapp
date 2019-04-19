import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ini/ini.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:rallyapp/blocs/app/month.dart';

import 'package:rallyapp/screens/loginScreen.dart';
import 'package:rallyapp/calendar/calendarScreen.dart';
import 'package:rallyapp/screens/friendsScreen.dart' ;
import 'package:rallyapp/screens/newEventScreen.dart';
import 'package:rallyapp/screens/settingsScreen.dart';
import 'package:rallyapp/screens/registerScreen.dart';

import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:rallyapp/blocs/events/event_bloc.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/blocs/app/indexBloc.dart';
import 'package:rallyapp/blocs/app/invite.dart';
import 'package:rallyapp/blocs/app/theme.dart';

import 'package:rallyapp/utility/config.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async{
  var themeValue;
  var config = await readConf();
  if(config is FileSystemException){
    writeToConf('');
    config = await readConf();
  } if(config.hasSection('theme')){
    themeValue = config.get('theme', 'appTheme');
  } else{
    themeValue = "light";
  }

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // NOTE: if you want to find out if the app was launched via notification then you could use the following call and then do something like
  // change the default route of the app
   var notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  runApp(Rally(themeValue));
}

class Rally extends StatelessWidget {
  final String themeValue;
  Rally(this.themeValue);

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders:[
        BlocProvider<FriendsBloc>(bloc: FriendsBloc()),
        BlocProvider<EventsBloc>(bloc: EventsBloc()),
        BlocProvider<AuthBloc>(bloc: AuthBloc()),
        BlocProvider<CalendarIndexBloc>(bloc: CalendarIndexBloc()),
        BlocProvider<MonthBloc>(bloc: MonthBloc()),
        BlocProvider<InviteBloc>(bloc: InviteBloc()),
        BlocProvider<ThemeBloc>(bloc: ThemeBloc()),
      ],
        child: Builder(builder: (context){
          ThemeBloc _themeBloc = BlocProvider.of<ThemeBloc>(context);
          _themeBloc.dispatch(ChangeTheme(themeValue));
          return BlocBuilder(bloc: _themeBloc, builder: (context, state){
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Rally',
              initialRoute: '/',
              routes: {
                '/': (context) => SignInPage(),
                '/register': (context) => RegisterPage(),
                '/main': (context) => CalendarPage(),
              },
            );
          });
        })
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
//    if (settings.isInitialRoute)
      return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
  }
}











