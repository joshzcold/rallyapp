import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/screens/friendEventScreen.dart';
import 'package:rallyapp/screens/userEventScreen.dart';
import 'package:sticky_headers/sticky_headers.dart';

var currentHour = new DateTime.now().hour;

List<int> timeHour = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23
];

List<int> columns = [1, 2, 3, 4, 5, 6, 7];


 calendar(BuildContext context, week){

    return LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            // You can change up this value later to increase or decrease the height
            // of the week grid.
            // If you change the +800 after maxHeightWanted, change that value in
            // the parent widget as well.
            double maxHeightWanted = viewportConstraints.maxHeight;
            double maxPossibleWidth = viewportConstraints.maxWidth;
            return Container(
                height: maxHeightWanted,
                width: maxPossibleWidth,
                child: Stack(
                  children: <Widget>[
                    Row(
                        children: columns
                            .map((columns) =>
                            Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                color: Color(0xFFdadce0),
                                                width: 1))),
                                    child: Column(
                                        children: timeHour
                                            .map((hour) =>
                                            Expanded(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Color(
                                                                    0xFFdadce0),
                                                                width: 1))),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container()
                                                      ],
                                                    ))))
                                            .toList()))))
                            .toList()),
                    eventCards(context, maxHeightWanted, maxPossibleWidth,
                        week),
                    currentTimeIndicator(context, maxHeightWanted, maxPossibleWidth, week)
                  ],
                ),
              );
          });
}


double moveIndicatorDownBasedOfConstraints(sTime, constraints) {
  double height = constraints;
  double hour = height / 24;
  var hoursFromMidnight = (sTime.hour * 60 + sTime.minute) / 60;
  double distanceDown = hoursFromMidnight * hour;
  return distanceDown;
}

  double moveIndicatorRightBasedOfConstraints(sTime, constraints) {
    double column = constraints / 7;
    var dayInWeek = sTime.weekday;
    if (dayInWeek == 7) {
      dayInWeek = 0;
    }
    return (dayInWeek * column);
  }


currentTimeIndicator(BuildContext context, double maxHeightWanted,
    double maxPossibleWidth, currentWeek) {
  DateTime cday = DateTime.now();
  bool check = false;
  for (DateTime day in currentWeek) {
    String value =
        day.year.toString() + day.month.toString() + day.day.toString();
    String today =
        cday.year.toString() + cday.month.toString() + cday.day.toString();
    if (today == value) {
      check = true;
      return Stack(
        children: <Widget>[
          Positioned(
            top: moveIndicatorDownBasedOfConstraints(cday, maxHeightWanted) - 10,
            left: moveIndicatorRightBasedOfConstraints(cday, maxPossibleWidth),
            child: Row(
              children: <Widget>[
                Container(
                  color: Colors.green,
                  width: maxPossibleWidth / 7 - 25,
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

  double getHeightByTime(event, constraints) {
    double height = constraints;
    double hour = height / 24;
    var sTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
    var eTime = DateTime.fromMillisecondsSinceEpoch(event.value['end']);
    var startValue = sTime.hour * 60 + sTime.minute;
    var endValue = eTime.hour * 60 + eTime.minute;
    var subtractedValue = endValue - startValue;
    double numOfHours = subtractedValue / 60;
    double result = hour * numOfHours;
    return result;
  }

  double getWidthByScreenSize(context) {
    double width = MediaQuery.of(context).size.width;
    double weekWidth = width / 8;
    double reducedWidth = weekWidth - 0;
    return reducedWidth;
  }

  double moveBoxDownBasedOfConstraints(event, constraints) {
    double height = constraints;
    double hour = height / 24;
    var sTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
    var hoursFromMidnight = (sTime.hour * 60 + sTime.minute) / 60;
    double distanceDown = hoursFromMidnight * hour;
    return distanceDown;
  }

  double moveBoxRightBasedOfConstraints(event, constraints) {
    double column = constraints / 7;
    var sTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
    var dayInWeek = sTime.weekday;
    if (dayInWeek == 7) {
      dayInWeek = 0;
    }
    return (dayInWeek * column);
  }

double moveJoinedFriendsRightBasedOfConstraints(event, constraints) {
   var adjustment = -10;
  double column = constraints / 7;
  var sTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
  var dayInWeek = sTime.weekday;
  if (dayInWeek == 7) {
    dayInWeek = 0;
    adjustment = 40;
  }
  return (dayInWeek * column) + adjustment;
}

  // Didn't want to do this function, but all our color values are in hex format
  int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  List<Widget> _joinedFriends(event) {
    if (event.value['party']['friends'] != null) {
      return event.value['party']['friends'].entries
          .map<Widget>((friend) => CircleAvatar(
        radius: 15,
        backgroundColor: Color(_getColorFromHex(event.value['color'])),
        backgroundImage: NetworkImage(friend
            .value['userPhoto']),
      ),)
          .toList();
    } else {
      return <Widget>[Container()];
    }
  }

  eventCards(context, maxHeight, maxWidth, week) {
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    final _authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder(
        bloc: _eventsBloc,
        builder: (BuildContext context, state) {
          Map<dynamic, dynamic> newDict = {};
          state.events.entries.forEach((item) => {
                item.value.forEach((key, value) {
                  int sTime = value['start'];
                  DateTime startWeek =
                      week.first.subtract(Duration(hours: 6));
                  DateTime endWeek = week.last
                      .add(Duration(hours: 18))
                      .subtract(Duration(minutes: 1));
                  if (sTime >= startWeek.millisecondsSinceEpoch &&
                      sTime <= endWeek.millisecondsSinceEpoch) {
                    newDict.addAll({key: value});
                  }
                }),
              });
          Map conflictingEvents = {};
          newDict.forEach((checkKey, checkValue){
            var cVStart = checkValue['start'];
            var cVEnd = checkValue['end'];
            newDict.forEach((loopKey, loopValue){
              var lVStart = loopValue['start'];
              var lVEnd = loopValue['end'];
              if(cVStart < lVStart && lVStart < cVEnd || lVEnd > cVStart && lVEnd < cVEnd){
                var key = DateTime.fromMillisecondsSinceEpoch(cVStart).day;
                if(conflictingEvents.containsKey(key)){
                  conflictingEvents[key].addAll({loopKey: loopValue});
                  conflictingEvents[key].addAll({checkKey: checkValue});
                }else{
                  conflictingEvents[key] = {};
                  conflictingEvents[key].addAll({loopKey: loopValue});
                  conflictingEvents[key].addAll({checkKey: checkValue});
                }
              }
            });
          });
          DateTime currentTime = DateTime.now();
          conflictingEvents.forEach((day, events){
            var startingHour;
            var endingHour;
            print('DAY: $day');
            timeHour.forEach((hour){
              var cHStart =  new DateTime(currentTime.year,currentTime.month, day, hour).millisecondsSinceEpoch;
              var cHEnd = cHStart + 3599999;
              int lastEndTimeValue;
              int lastGroup;
              events.forEach((eventKey, eventValue){
                var eStart = eventValue['start'];
                var eEnd = eventValue['end'];
                if(cHStart >= eStart && cHStart < eEnd || cHEnd >= eStart && cHEnd <= eEnd || cHStart <= eStart && cHEnd >= eEnd ){
                  print('BING!: Hour:$hour event Start:$eStart event End:$eEnd');
                 if(lastEndTimeValue == null || lastEndTimeValue < eEnd){
                   lastEndTimeValue = eEnd;
                   if(lastGroup == null || lastGroup < hour && lastEndTimeValue > cHStart){
                     lastGroup = hour;
//                     print('$lastGroup');
                   }
                 }
                }
              });
            });
          });
          return Stack(
              children: newDict.entries
                  .map<Widget>((event) => Stack(
                        children: <Widget>[
                          Positioned(
                            height: getHeightByTime(event, maxHeight),
                            width: getWidthByScreenSize(context),
                            top:
                                moveBoxDownBasedOfConstraints(event, maxHeight),
                            left:
                                moveBoxRightBasedOfConstraints(event, maxWidth),
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              color:
                                  Color(_getColorFromHex(event.value['color'])),
                              child: BlocBuilder(bloc: _authBloc, builder:(context, auth){
                                return FlatButton(
                                clipBehavior: Clip.hardEdge,
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                onPressed: () {
                                  if(auth.key == event.value['user']){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserEvent(event: event,)));
                                  } else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => FriendEvent(event: event,)));
                                  }
                                },
                                child: ListView(
                                  padding: EdgeInsets.all(0),
                                  children: <Widget>[
                                    // User Image
                                    LayoutBuilder(builder: (context, constraints){
                                      return CircleAvatar(
                                        backgroundColor: Color(_getColorFromHex(event.value['color'])),
                                        radius: constraints.maxWidth/2,
                                        backgroundImage: NetworkImage(event
                                            .value['userPhoto']),
                                      );
                                    },),
                                    // User Name & Description
                                    Column(
                                      children: <Widget>[
                                        Text(event.value['userName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
                                        Text(event.value['title'], style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),)
                                      ],
                                    )
                                  ],
                                ),
                              );
                              })
                            ),
                          ),
                          Positioned(
                            height: getHeightByTime(event, maxHeight) + 100,
                            width: 20,
                            top: moveBoxDownBasedOfConstraints(event, maxHeight),
                            left: moveJoinedFriendsRightBasedOfConstraints(event, maxWidth),
                            child: GridView.count(
                                primary: false,
                                padding: const EdgeInsets.all(0),
                                crossAxisSpacing: 0,
                                crossAxisCount: 1,
                                children: _joinedFriends(event)),
                          )
                        ],
                      ))
                  .toList());
        });
  }