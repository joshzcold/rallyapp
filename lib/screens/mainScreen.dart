import 'dart:async';

import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rallyapp/blocs/app/indexBloc.dart';

import 'package:rallyapp/calendar/week/weekView.dart';
import 'package:rallyapp/calendar/month/monthView.dart';
import 'package:rallyapp/calendar/agenda/agendaView.dart';
import 'package:rallyapp/calendar/upcoming/upcomingView.dart';
import 'package:rallyapp/calendar/calendarScreen.dart';
import 'package:rallyapp/screens/friendsScreen.dart';


class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _calendarEventIndex = BlocProvider.of<CalendarIndexBloc>(context);
    return Scaffold(
      body: BlocBuilder(
        bloc: _calendarEventIndex,
        builder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return CalendarPage();
              break;
            case 1:
              return FriendsScreen();
              break;
          }
        },
      ),
      bottomNavigationBar: BlocBuilder(
          bloc: _calendarEventIndex,
          builder: (BuildContext context, int index) {
            return BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today), title: Text('Events')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.group), title: Text('Friends')),
                ],
                currentIndex: index,
                fixedColor: Colors.blue,
                onTap: (index){
                  if(index == 0){
                    _calendarEventIndex.dispatch(CalendarIndexEvent.week);
                  } else if(index == 1){
                    _calendarEventIndex.dispatch(CalendarIndexEvent.friends);
                  }
                });
          }),
    );
  }
}
