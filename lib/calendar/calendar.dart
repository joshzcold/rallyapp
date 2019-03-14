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
import 'package:rallyapp/calendar/calendarHeading.dart';
import 'package:rallyapp/screens/friendsScreen.dart';

class Calendar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final CalendarIndexBloc _calendarIndexBloc = BlocProvider.of<CalendarIndexBloc>(context);
    return Column(
        children: <Widget>[
          CalendarHeading(
            headerMargin: EdgeInsets.all(8.0),
            headerButtonsColor: Colors.black,
          ),
          BlocBuilder(
            bloc: _calendarIndexBloc,
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
        ],
      );
  }
}