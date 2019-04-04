import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/invite.dart';
import 'package:rallyapp/blocs/app/month.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/calendar/week/weekView.dart';
import 'package:rallyapp/screens/friendsScreen.dart';
import 'package:rallyapp/screens/newEventScreen.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:rallyapp/main.dart';

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

double leftColumnWidth = 50;

/// This is rendering how many pages back we want to allow the user to scroll
/// for the top header this number needs to be divisible by 7.
int pages = 53;
int daysBeforeStart = pages * 7;

/// These two controllers are meant to work together by sync scrolling
PageController pageController;
PageController horizontalHeaderScrollController;

ScrollController verticalPageGridScrollController;


class CalendarPage extends StatelessWidget {
  int currentMonth;
  int calculatedDayNumber = daysBeforeStart;

  @override
  Widget build(BuildContext context) {
    horizontalHeaderScrollController = PageController(
        initialPage: pages
    );
    var maxHeightWanted =
        MediaQuery.of(context).size.height + 800;
    verticalPageGridScrollController = ScrollController(
        initialScrollOffset: calculateInitialScrollDownByCurrentTime(maxHeightWanted)
    );
    var maxPossibleWidth = MediaQuery.of(context).size.width;
    var leftTimeColumnWidth = 50.0;
    var calendarColumnWidths = (MediaQuery.of(context).size.width - leftColumnWidth)/7;
    final EventsBloc _eventsBloc = BlocProvider.of<EventsBloc>(context);

    var currentDay = DateTime.now();
    var startOfWeek = Utils.firstDayOfWeek(currentDay).toLocal();
    var endOfWeek = Utils.lastDayOfWeek(currentDay).toLocal();
    var currentWeek = Utils.daysInRange(startOfWeek, endOfWeek).toList();

    pageController = PageController(initialPage: pages);
    currentMonth = Utils.firstDayOfWeek(DateTime.now()).toLocal().month;

    final monthBloc = BlocProvider.of<MonthBloc>(context);
    final inviteBloc = BlocProvider.of<InviteBloc>(context);



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
                      appBar: PreferredSize(
                          child: AppBar(
                            elevation: 0.0,
                            backgroundColor: Colors.white,
                          ),
                          preferredSize: Size.fromHeight(1)),
                      bottomNavigationBar: BottomAppBar(
                      child: Container(
                        height: 55,
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: (){
                                  pageController.animateToPage(pages, duration: Duration(seconds: 1), curve: Curves.easeOut);
                                },
                              child:  Container(
                              width: maxPossibleWidth/2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.today, color: Colors.grey,),
                                  Text('Today', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),)
                                ],
                              ),
                            )),
                            FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: (){
                                Navigator.push(context, MyCustomRoute(builder: (context) => FriendsScreen()));
                              },
                              child: Container(
                                width: maxPossibleWidth/2,
                                child: LayoutBuilder(builder: (context, constraints){
                                  return Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Column(
                                          children: <Widget>[
                                            Icon(Icons.group, color: Colors.grey,),
                                            Text('Friends', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.center,
                                        ),
                                      ),
                                      BlocBuilder(bloc: inviteBloc, builder: (context, state){
                                        if(state is InvitesLoaded && state.invites.length > 0){
                                          return Positioned(
                                                top: constraints.maxHeight/4 - 5,
                                                left: constraints.maxWidth/2 + 5,
                                                child: Container(
                                                  height: 15,
                                                  width: 15,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.green
                                                  ),
                                                  child: Center(
                                                    child:Text('${state.invites.length}', style:
                                                    TextStyle(color: Colors.white, fontSize: 14),),
                                                  )
                                                ));
                                        } else{
                                          return Container();
                                        }
                                      },),
                                    ],
                                  );
                                })

                              ),
                            )
                          ],
                        ),
                      )
                      ),
                      floatingActionButton: Container(
                        child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewEvent()));
                            },
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.add)),
                      ),
                      body: ListView(
                        controller: verticalPageGridScrollController,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  width: 50,
                                  child:StickyHeader(
                                      header: BlocBuilder(bloc: monthBloc, builder: (context, state){
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                new BoxShadow(
                                                spreadRadius: MediaQuery.of(context).size.width,
                                                  color: Colors.grey[500],
                                                  blurRadius: 5.0,
                                                offset: Offset(0.0, -MediaQuery.of(context).size.width),
                                                )
                                              ]),
                                          height: 50.0,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: leftTimeColumnWidth,
                                                child: new Text(
                                                  "${calculateMonthToAbbrv(state.month)}",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),

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
                                                          width: leftTimeColumnWidth,
                                                          height: maxHeightWanted / 24,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Text('$hour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey),)
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

                              StickyHeader(
                                    header: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      width: maxPossibleWidth -50,
                                      height: 50,
                                      child: NotificationListener<ScrollNotification>(
                                          onNotification: (scrollInfo){
                                            var value = (pageController.offset - calendarColumnWidths/2)/calendarColumnWidths;
                                            var roundedValue = value.round();
                                            Month currentMonth = monthBloc.currentState;
                                            var date = startOfWeek.add(Duration(days: (roundedValue - daysBeforeStart)));
                                            if(date.month > currentMonth.month || date.month < currentMonth.month){
                                              monthBloc.dispatch(ChangeMonth(date.month));
                                            }
                                          },
                                          child:ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis.horizontal,
                                                  controller: horizontalHeaderScrollController,
                                                  itemBuilder: (context, _index){
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
                                                    return Row(
                                                      children: week.map<Widget>((day) => calculateDayStyle(day, leftColumnWidth, context)).toList(),
                                                    );
                                                  })

                                      )
                                    ),
                                    content: Container(
                                        width: maxPossibleWidth -50,
                                        height: maxHeightWanted,
                                        child: NotificationListener<ScrollNotification>(
                                            onNotification: (ScrollNotification scrollInfo){
                                              horizontalHeaderScrollController.jumpTo(pageController.offset);
                                            },
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
                                            return WeekView(week: week);
                                          },
                                        ))
                                    )
                                ),
                            ],
                          ),
                        ],
                      )
                  );
                }
              });

  }

  calculateDayStyle(DateTime day, width, context) {
    DateTime cday = DateTime.now();
    String value =
        day.year.toString() + day.month.toString() + day.day.toString();
    String today =
        cday.year.toString() + cday.month.toString() + cday.day.toString();
    if (value == today) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        width: (MediaQuery.of(context).size.width - leftColumnWidth)/7,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${day.day}",
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
            ),
            Text(
              "${calculateWeekDayAbbrv(day.weekday)}",
              style: TextStyle(color: Colors.blue, fontSize: 10.0),
            ),
          ],),
        alignment: FractionalOffset(0.5, 0.5),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        width: (MediaQuery.of(context).size.width - leftColumnWidth)/7,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text(
            "${day.day}",
            style: TextStyle(color: Colors.grey, fontSize: 20.0),
          ),
          Text(
            "${calculateWeekDayAbbrv(day.weekday)}",
            style: TextStyle(color: Colors.grey, fontSize: 10.0),
          ),
        ],),
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

calculateWeekDayAbbrv(int weekday) {
  var result = "";
  switch (weekday) {
    case 1:
      result = "M";
      break;
    case 2:
      result = "T";
      break;
    case 3:
      result = "W";
      break;
    case 4:
      result = "T";
      break;
    case 5:
      result = "F";
      break;
    case 6:
      result = "S";
      break;
    case 7:
      result = "S";
      break;
  }
  return result;
}


double calculateInitialScrollDownByCurrentTime(constraints) {
  var sTime = DateTime.now();
  double height = constraints;
  double hour = height / 24;
  var hoursFromMidnight = (sTime.hour * 60 + sTime.minute) / 60;
  double distanceDown = hoursFromMidnight * hour;
  return distanceDown/1.5;
}

