import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rallyapp/screens/loginScreen.dart';
import 'package:rallyapp/screens/mainScreen.dart';
import 'package:rallyapp/screens/settingsScreen.dart';
import 'package:rallyapp/screens/registerScreen.dart';
import 'package:rallyapp/calendar/calendarScreen.dart';

import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:rallyapp/blocs/events/event_bloc.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/blocs/app/indexBloc.dart';
import 'package:rallyapp/blocs/date_week/date_week.dart';

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
        BlocProvider<DateWeekBloc>(bloc: DateWeekBloc()),
      ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Rally',
          initialRoute: '/',
          routes: {
            '/': (context) => SignInPage(),
            '/register': (context) => RegisterPage(),
            '/main': (context) => MainScreen(),
            '/settings': (context) => Settings(),
          },
        )
    );
  }
}











