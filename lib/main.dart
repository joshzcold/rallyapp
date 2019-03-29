import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

void main() {
runApp(Rally());
}

class Rally extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders:[
        BlocProvider<FriendsBloc>(bloc: FriendsBloc()),
        BlocProvider<EventsBloc>(bloc: EventsBloc()),
        BlocProvider<AuthBloc>(bloc: AuthBloc()),
        BlocProvider<CalendarIndexBloc>(bloc: CalendarIndexBloc()),
      ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Rally',
          initialRoute: '/',
          routes: {
            '/': (context) => SignInPage(),
            '/register': (context) => RegisterPage(),
            '/main': (context) => CalendarPage(),
            '/friends': (context) => FriendsScreen(),
            '/settings': (context) => Settings(),
            '/newEvent': (context) => NewEvent()
          },
        )
    );
  }
}











