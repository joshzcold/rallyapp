import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/blocs/date_week/date_week.dart';
import 'package:rallyapp/calendar/week/weekView.dart';
import 'package:sticky_headers/sticky_headers.dart';

List<String> displayHour = [
  "1AM",
  "2AM",
  "3AM",
  "4AM",
  "5AM",
  "6AM",
  "7AM",
  "8AM",
  "9AM",
  "10AM",
  "11AM",
  "12PM",
  "1PM",
  "2PM",
  "3PM",
  "4PM",
  "5PM",
  "6PM",
  "7PM",
  "8PM",
  "9PM",
  "10PM",
  "11PM"
];

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var maxHeightWanted =
        MediaQuery.of(context).size.height + 800;
    var maxPossibleWidth = MediaQuery.of(context).size.width;
    var leftTimeColumnWidth = 50.0;
    Key forwardListKey = UniqueKey();
    final EventsBloc _eventsBloc = BlocProvider.of<EventsBloc>(context);
    final DateWeekBloc _dateWeekBloc = BlocProvider.of<DateWeekBloc>(context);

    Widget forwardList = SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          width: maxPossibleWidth -leftTimeColumnWidth,
          child: ListView(
            children: <Widget>[
              Calendar(),
            ],
          ),
        );
      }),
      key: forwardListKey,
    );

    Widget reverseList = SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          width: maxPossibleWidth -leftTimeColumnWidth,
          child: ListView(
            children: <Widget>[
              Calendar(),
            ],
          ),
        );
      }),
    );

    return BlocBuilder(
        bloc: _dateWeekBloc,
        builder: (BuildContext context, week) {
          DateTime startOfWeek = week.week.first;
          return BlocBuilder(
              bloc: _eventsBloc,
              builder: (BuildContext context, state) {
                if (state is EventsLoading) {
                  print('EventsLoading...');
//              return Calendar();
                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is EventsLoaded) {

                  return Scaffold(
                      floatingActionButton: Container(
                        child: FloatingActionButton(
                            onPressed: () {},
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.add)),
                      ),
                      body: Row(
                          children: <Widget>[
                            Container(
                              width: 50,
                              child: ListView(
                                children: <Widget>[
                                  StickyHeader(
                                      header: new Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.grey[500],
                                                blurRadius: 5.0,
                                              )
                                            ]),
                                        height: 50.0,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              width: leftTimeColumnWidth,
                                              child: new Text(
                                                "${calculateMonthToAbbrv(startOfWeek.month)}",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 20.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// This is the Column on the left displaying time information
                                      content: Container(
                                          height: maxHeightWanted,
                                          width: leftTimeColumnWidth,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                                      color: Color(0xFFdadce0),
                                                      width: 1))),
                                          child: Stack(
                                            children: <Widget>[
                                              /// These are the time increments
                                              Positioned(
                                                  left: 5,
                                                  top: maxHeightWanted / 24 / 2,
                                                  child: Column(
                                                      children: displayHour
                                                          .map((hour) => Container(
                                                          width:
                                                          leftTimeColumnWidth,
                                                          height:
                                                          maxHeightWanted /
                                                              24,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: <Widget>[
                                                              RichText(
                                                                text: TextSpan(
                                                                    style: DefaultTextStyle.of(
                                                                        context)
                                                                        .style,
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                          '$hour',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12)),
                                                                    ]),
                                                              ),
                                                            ],
                                                          )))
                                                          .toList())),

                                              /// This creates the little ticks next to the Time increments
                                              Positioned(
                                                  left: 35,
                                                  child: Column(
                                                      children: timeHour
                                                          .map((hour) => Container(
                                                          width: 15,
                                                          height:
                                                          maxHeightWanted /
                                                              24,
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      color: Color(
                                                                          0xFFdadce0),
                                                                      width:
                                                                      1))),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container()
                                                            ],
                                                          )))
                                                          .toList())),
                                              currentTimeIndicator(
                                                  context,
                                                  maxHeightWanted,
                                                  maxPossibleWidth,
                                                  week,
                                                  leftTimeColumnWidth)
                                            ],
                                          )))
                                ],
                              ),
                            ),

                            Container(
                              width: maxPossibleWidth -50,
                              height: maxHeightWanted,
                              child: Scrollable(
                                  axisDirection: AxisDirection.right,
                                  viewportBuilder: (context, ViewportOffset offset){
                                    return Viewport(
                                      axisDirection: AxisDirection.right,
                                        offset: offset,
                                        center: forwardListKey,
                                        slivers: [
                                          reverseList,
                                          forwardList,
                                        ]);
                                  }
                              ),
                            )
                          ],
                        ),
                      );
                }
              });
        });
  }

  double moveIndicatorDownBasedOfConstraints(sTime, constraints) {
    double height = constraints;
    double hour = height / 24;
    var hoursFromMidnight = (sTime.hour * 60 + sTime.minute) / 60;
    double distanceDown = hoursFromMidnight * hour;
    return distanceDown;
  }

  currentTimeIndicator(BuildContext context, double maxHeightWanted,
      double maxPossibleWidth, currentWeek, leftTimeColumnWidth) {
    DateTime cday = DateTime.now();
    bool check = false;
    for (DateTime day in currentWeek.week) {
      String value =
          day.year.toString() + day.month.toString() + day.day.toString();
      String today =
          cday.year.toString() + cday.month.toString() + cday.day.toString();
      if (today == value) {
        check = true;
        return Stack(
          children: <Widget>[
            Positioned(
              top: moveIndicatorDownBasedOfConstraints(cday, maxHeightWanted) -
                  10,
              left: 0,
//              moveIndicatorRightBasedOfConstraints(cday, maxPossibleWidth),
              child: Row(
                children: <Widget>[
                  Container(
                    color: Colors.green,
                    width: leftTimeColumnWidth / 2,
                    height: 3,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ],
              ),
            )
          ],
        );
      }
    }
    if (check == false) {
      return Container();
    }
  }

  String calculateMonthToAbbrv(int month) {
    var result = "";
    switch (month) {
      case 1:
        result = "Jan";
        break;
      case 2:
        result = "Feb";
        break;
      case 3:
        result = "Mar";
        break;
      case 4:
        result = "Apr";
        break;
      case 5:
        result = "May";
        break;
      case 6:
        result = "Jun";
        break;
      case 7:
        result = "Jul";
        break;
      case 8:
        result = "Aug";
        break;
      case 9:
        result = "Sep";
        break;
      case 10:
        result = "Oct";
        break;
      case 11:
        result = "Nov";
        break;
      case 12:
        result = "Dec";
        break;
    }
    return result;
  }
}

//AppBar(
//                    leading: new Center(
//                      child: Container(
//                        decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: Color.fromARGB(255, 255, 255, 255),
//                        ),
//                        width: width / 8,
//                        child: new Text(
//                          "${calculateMonthToAbbrv(startOfWeek.month)}",
//                          style: TextStyle(
//                              color: Colors.grey, fontSize: 20.0),
//                        ),
//                        alignment: FractionalOffset(0.5, 0.5),
//                      ),
//                    ),
//                    backgroundColor: Colors.white,
//                    actions: week.week
//                        .map<Widget>((DateTime day) => Center(
//                              child: calculateDayStyle(day, width)
//                            ))
//                        .toList())
