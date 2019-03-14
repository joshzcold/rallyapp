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
import 'package:rallyapp/screens/friendsScreen.dart';

final headerButtonsColor = Colors.black;

class Calendar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final _calendarEventIndex = BlocProvider.of<CalendarIndexBloc>(context);
    return Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.white,
          leading: _menu(context),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _calendarEventIndex.dispatch(CalendarIndexEvent.friends);
              },
              icon: Icon(Icons.group, color: headerButtonsColor),
            ),
            IconButton(
              onPressed: () {
                _calendarEventIndex.dispatch(CalendarIndexEvent.week);
              },
              icon: Icon(
                Icons.calendar_today,
                color: headerButtonsColor,
              ),
            ),
          ],
        ),
          body: BlocBuilder(
            bloc: _calendarEventIndex,
            builder: (BuildContext context, int index){
              switch(index){
                case 0:
                  return Week();
                  break;
                case 1:
                  return Container();
                  break;
                case 2:
                  return Container();
                  break;
                case 3:
                  return Container();
                  break;
                case 4:
                  return FriendsScreen();
                  break;
              }
            },
          ),
          floatingActionButton:
          Container(
            child: FloatingActionButton(
                onPressed: (){},
                backgroundColor: Colors.blue,
                child: Icon(Icons.add)
            ),
          ),
      );
  }

  Widget _menu(
      context,
      ) =>
      IconButton(
        onPressed: onMenuButtonPressed(
          context,
        ),
        icon: Icon(
          Icons.menu,
          color: headerButtonsColor,
        ),
      );

  onMenuButtonPressed(context) {}
}