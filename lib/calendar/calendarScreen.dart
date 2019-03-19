import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/blocs/date_week/date_week.dart';
import 'package:rallyapp/calendar/week/weekView.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EventsBloc _eventsBloc = BlocProvider.of<EventsBloc>(context);
    final DateWeekBloc _dateWeekBloc = BlocProvider.of<DateWeekBloc>(context);

    return BlocBuilder(
        bloc: _dateWeekBloc,
        builder: (BuildContext context, week) {
          DateTime startOfWeek = week.week.first;
          double width = MediaQuery.of(context).size.width;
          return Scaffold(
            appBar: PreferredSize(
                child: AppBar(
                    leading: new Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        width: width / 8,
                        child: new Text(
                          "${calculateMonthToAbbrv(startOfWeek.month)}",
                          style: TextStyle(
                              color: Colors.grey, fontSize: 20.0),
                        ),
                        alignment: FractionalOffset(0.5, 0.5),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    actions: week.week
                        .map<Widget>((DateTime day) => Center(
                              child: calculateDayStyle(day, width)
                            ))
                        .toList()),
                preferredSize: Size.fromHeight(50)),
            body: BlocBuilder(
                bloc: _eventsBloc,
                builder: (BuildContext context, state) {
                  if (state is EventsLoading) {
                    print('EventsLoading...');
//              return Calendar();
                    return new Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is EventsLoaded) {
                    return Calendar();
                  }
                }),
            floatingActionButton: Container(
              child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.add)),
            ),
          );
        });
  }

  String calculateMonthToAbbrv(int month) {
    var result = "";
    switch (month) {
      case 1 :
        result = "Jan";
        break;
      case 2 :
        result = "Feb";
        break;
      case 3 :
        result = "Mar";
        break;
      case 4 :
        result = "Apr";
        break;
      case 5 :
        result = "May";
        break;
      case 6 :
        result = "Jun";
        break;
      case 7 :
        result = "Jul";
        break;
      case 8 :
        result = "Aug";
        break;
      case 9 :
        result = "Sep";
        break;
      case 10 :
        result = "Oct";
        break;
      case 11 :
        result = "Nov";
        break;
      case 12 :
        result = "Dec";
        break;
    }
    return result;
  }

  calculateDayStyle(DateTime day, width) {
    DateTime cday = DateTime.now();
    String value = day.year.toString()+day.month.toString()+day.day.toString();
    String today = cday.year.toString()+cday.month.toString()+cday.day.toString();
    if( value == today){
      return  Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 150, 150, 150),
        ),
        width: width / 8,
        child: new Text(
          "${day.day}",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0),
        ),
        alignment: FractionalOffset(0.5, 0.5),
      );
    } else{
      return  Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        width: width / 8,
        child: new Text(
          "${day.day}",
          style: TextStyle(
              color: Colors.grey, fontSize: 20.0),
        ),
        alignment: FractionalOffset(0.5, 0.5),
      );
    }
  }
}
