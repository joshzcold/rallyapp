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

/// This is rendering how many pages back we want to allow the user to scroll
/// for the top header this number needs to be divisible by 7.
int pages = 53;

PageController pageController;
ScrollController horizontalHeaderScrollController;

class CalendarPage extends StatefulWidget{
  @override
  CalendarPageState createState() => CalendarPageState();

}

class CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    pageController = PageController(initialPage: pages);
    horizontalHeaderScrollController = ScrollController(
      initialScrollOffset: 50*7*pages.toDouble()
    );
    super.initState();
  }


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
    var startOfLastWeek = startOfWeek.subtract(Duration(days: 7));

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
                      body: ListView(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  width: 50,
                                  child:StickyHeader(
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

                              ),

                              /// Horizontally scrolling set of calendar widgets
                              /// that get defined at the top of the class.

                              NotificationListener<ScrollNotification>(
                                onNotification: (ScrollNotification scrollInfo){
                                  print('${horizontalHeaderScrollController.offset}');
                                  print('${pageController.offset}');
                                  horizontalHeaderScrollController.jumpTo(pageController.offset);
//                                  print('check -- offset Left: '+horizontalHeaderScrollController.offset.toInt().toString()+ ' -- offset Right: '+pageController.offset.toInt().toString());
                                },
                                child: StickyHeader(
                                    header: Container(
                                      color: Colors.white,
                                      width: maxPossibleWidth -50,
                                      height: 50,
                                      child: CustomScrollView(
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        controller: horizontalHeaderScrollController,
                                        slivers: <Widget>[
                                          SliverList(
                                            delegate: SliverChildBuilderDelegate((context, index){
                                              var yearsBack = startOfWeek.subtract(Duration(days: pages * 7));
                                              DateTime day;
                                              day = yearsBack.add(Duration(days: index));
                                              return calculateDayStyle(day, columnWidths);
                                            }),
                                          )
                                        ],
                                      )
                                    ),
                                    content: Container(
                                        width: maxPossibleWidth -50,
                                        height: maxHeightWanted,
                                        child: PageView.builder(
                                          controller: pageController,
                                          itemBuilder: (context, _index) {
                                            final index =  _index - pages;
                                            var week = [];
                                            if(index == 0){
                                              week = currentWeek;
                                              // if statement accounts for daylight savings messing with daysInRage
                                              if(week.length == 8){
                                                week.removeLast();
                                              }
                                            } else{
                                              var startofWeek = startOfWeek.add(Duration(days: index*7));
                                              var endofWeek = Utils.lastDayOfWeek(startofWeek);
                                              week = Utils.daysInRange(startofWeek, endofWeek).toList();
                                              // if statement accounts for daylight savings messing with daysInRage
                                              if(week.length == 8){
                                                week.removeLast();
                                              }
                                            }
                                            return Container(
                                              width: columnWidths,
                                              child: calendar(context, week),
                                            );
                                          },
                                        )
                                    )
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                  );
                }
              });

  }


  calculateDayStyle(DateTime day, width) {
    DateTime cday = DateTime.now();
    String value =
        day.year.toString() + day.month.toString() + day.day.toString();
    String today =
        cday.year.toString() + cday.month.toString() + cday.day.toString();
    if (value == today) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 150, 150, 150),
        ),
        width: (MediaQuery.of(context).size.width - columnWidths)/7,
        child: new Text(
          "${day.day}",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        alignment: FractionalOffset(0.5, 0.5),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        width: (MediaQuery.of(context).size.width - columnWidths)/7,
        child: new Text(
          "${day.day}",
          style: TextStyle(color: Colors.grey, fontSize: 20.0),
        ),
        alignment: FractionalOffset(0.5, 0.5),
      );
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

