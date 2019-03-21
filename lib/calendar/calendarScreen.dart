import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
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

double columnWidths = 50;

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var maxHeightWanted =
        MediaQuery.of(context).size.height + 800;
    var maxPossibleWidth = MediaQuery.of(context).size.width;
    var leftTimeColumnWidth = 50.0;
    Key forwardListKey = UniqueKey();
    final EventsBloc _eventsBloc = BlocProvider.of<EventsBloc>(context);

    var currentDay = DateTime.now();
    var startOfWeek = Utils.firstDayOfWeek(currentDay).toLocal();
    var endOfWeek = Utils.lastDayOfWeek(currentDay).toLocal();
    var currentWeek = Utils.daysInRange(startOfWeek, endOfWeek).toList();

    Widget forwardList = SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        var day = currentDay.add(Duration(days: index));
        return Container(
          width: columnWidths,
          child: ListView(
            children: <Widget>[
              calendar(context, day),
            ],
          ),
        );
      }),
      key: forwardListKey,
    );

    Widget reverseList = SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        var day;
        if(index == 0){
           day = currentDay.subtract(Duration(days: 1));
        } else{
           day = currentDay.subtract(Duration(days: index + 1));
        }
        return Container(
          width: columnWidths,
          child: ListView(
            children: <Widget>[
              calendar(context, day),
            ],
          ),
        );
      }),
    );


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
                                DateTime startOfWeek = currentWeek.first;

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
                                            ],
                                          )))
                                ],
                              ),
                            ),

                            /// Horizontally scrolling set of calendar widgets
                            /// that get defined at the top of the class.
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

