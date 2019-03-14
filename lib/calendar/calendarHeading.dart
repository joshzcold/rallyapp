import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/indexBloc.dart';

class CalendarHeading extends StatelessWidget {
  CalendarHeading({
    @required this.headerMargin,
    @required this.headerButtonsColor,
    @required this.appBarColor,
  });

  final Color headerButtonsColor;
  final EdgeInsetsGeometry headerMargin;
  final Color appBarColor;

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

  @override
  Widget build(BuildContext context) {
    final _calendarEventIndex = BlocProvider.of<CalendarIndexBloc>(context);
    return AppBar(
      backgroundColor: appBarColor,
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
      );
  }

  onJumpToTodayPressed(context) {}

  onMenuButtonPressed(context) {}
}
