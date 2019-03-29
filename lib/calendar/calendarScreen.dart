import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/calendar/week/weekView.dart';
import 'package:rallyapp/screens/friendsScreen.dart';
import 'package:rallyapp/screens/newEventScreen.dart';
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

double leftColumnWidth = 50;

/// This is rendering how many pages back we want to allow the user to scroll
/// for the top header this number needs to be divisible by 7.
int pages = 53;
int daysBeforeStart = pages * 7;

/// These two controllers are meant to work together by sync scrolling
PageController pageController;
PageController horizontalHeaderScrollController;

ScrollController verticalPageGridScrollController;

class CalendarPage extends StatefulWidget{
  @override
  CalendarPageState createState() => CalendarPageState();

}

class CalendarPageState extends State<CalendarPage> {
  var listViewKey = RectGetter.createGlobalKey();
  var _keys = {};
  int currentMonth;
  int calculatedDayNumber = daysBeforeStart;



  @override
  void initState() {
    pageController = PageController(initialPage: pages);
    currentMonth = Utils.firstDayOfWeek(DateTime.now()).toLocal().month;
    super.initState();
  }


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
    var yearsBack = startOfWeek.subtract(Duration(days: pages * 7));

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
                      bottomNavigationBar: BottomNavigationBar(
                                items: <BottomNavigationBarItem>[
                                  BottomNavigationBarItem(
                                      icon: Icon(Icons.today), title: Text('Today')),
                                  BottomNavigationBarItem(
                                      icon: Icon(Icons.group), title: Text('Friends')),
                                ],
                                currentIndex: 0,
                                fixedColor: Colors.blue,
                                onTap: (index) {
                                  if (index == 0) {
                                    pageController.animateToPage(pages, duration: Duration(seconds: 1), curve: Curves.easeOut);
                                  } else if (index == 1) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsScreen()));
                                  }
                                }),
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
                                      header: new Container(
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
                                                "${calculateMonthToAbbrv(currentMonth)}",
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

                              StickyHeader(
                                    header: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      width: maxPossibleWidth -50,
                                      height: 50,
                                      child: NotificationListener<ScrollNotification>(
                                          onNotification: (scrollInfo){
                                            var value = (horizontalHeaderScrollController.offset - calendarColumnWidths/2)/calendarColumnWidths;
                                            var roundedValue = value.round();
                                            if(roundedValue > calculatedDayNumber || roundedValue < calculatedDayNumber){
                                              var date = startOfWeek.add(Duration(days: (roundedValue - daysBeforeStart)));
                                              setState(() {
                                                currentMonth = date.month;
                                                calculatedDayNumber = roundedValue;
                                              });
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
                                                      children: week.map<Widget>((day) => calculateDayStyle(day, leftColumnWidth)).toList(),
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
                                            return calendar(context, week);
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


  List<int> getVisible() {
    /// First, get the rect of ListView, and then traver the _keys
    /// get rect of each item by keys in _keys, and if this rect in the range of ListView's rect,
    /// add the index into result list.
    var rect = RectGetter.getRectFromKey(listViewKey);
    var _items = <int>[];
    _keys.forEach((index, key) {
      var itemRect = RectGetter.getRectFromKey(key);
      if (itemRect != null && !(itemRect.top > rect.bottom || itemRect.bottom < rect.top)) _items.add(index);
    });

    /// so all visible item's index are in this _items.
    return _items;
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

