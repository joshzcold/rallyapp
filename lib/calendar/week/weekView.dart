import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/calendar/calendarScreen.dart';
import 'package:rallyapp/screens/friendEventScreen.dart';
import 'package:rallyapp/screens/userEventScreen.dart';
import 'package:uuid/uuid.dart';

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

class WeekView extends StatefulWidget{
  final List week;
  final Function conflictEventsDetailsCallBack;
  WeekView({@required this.week, this.conflictEventsDetailsCallBack});

  @override
  WeekViewState createState() => WeekViewState();
}

class WeekViewState extends State<WeekView>{
  @override
  Widget build(BuildContext context) {
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
            eventCards(context, maxHeightWanted, maxPossibleWidth, this.widget.week, this.widget.conflictEventsDetailsCallBack),
            currentTimeIndicator(context, maxHeightWanted, maxPossibleWidth, this.widget.week),
          ],
        ),
      );
    });
  }
}

eventCards(context, maxHeight, maxWidth, week ,conflictEventsDetailsCallBack) {
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
        Map nonConflictingEvents = Map.from(newDict);

        /// Filter out events that detect a collision
        var uuid = new Uuid();
        newDict.forEach((checkKey, checkValue){
          var cVStart = checkValue['start'];
          var cVEnd = checkValue['end'];
          newDict.forEach((loopKey, loopValue){
            var lVStart = loopValue['start'];
            var lVEnd = loopValue['end'];
            if(cVStart < lVStart && lVStart < cVEnd || lVEnd > cVStart && lVEnd < cVEnd){
              var key = loopKey;
              if(conflictingEvents.containsKey(key)){
                conflictingEvents[key].addAll({loopKey: loopValue});
                conflictingEvents[key].addAll({checkKey: checkValue});
                nonConflictingEvents.remove(loopKey);
              }else{
                conflictingEvents[key] = {};
                conflictingEvents[key].addAll({loopKey: loopValue});
                conflictingEvents[key].addAll({checkKey: checkValue});
                nonConflictingEvents.remove(loopKey);
              }
            }
          });
        });

        /// Rounds of filtering that compare groups finds similarities
        /// if a compared group has any found events from the check group
        /// then the filter adds the biggest one
        var firstFilterMap = {};

        conflictingEvents.forEach((key, group){
          var mapKey = uuid.v4();
          group.forEach((eventKey, eventValue){
            var comparisonKey = eventKey;
            conflictingEvents.forEach((key, secondGroup){
              secondGroup.forEach((secondKey, secondValue){
                if(secondGroup.containsKey(comparisonKey) && group.length <= secondGroup.length){
                  if(firstFilterMap[mapKey] == null){firstFilterMap[mapKey] = {};}
                  firstFilterMap[mapKey].addAll(secondGroup);
                }
              });
            });
          });
        });

        var secondFilterMap = {};

        firstFilterMap.forEach((key, group){
          var mapKey = uuid.v4();
          group.forEach((eventKey, eventValue){
            var comparisonKey = eventKey;
            firstFilterMap.forEach((key, secondGroup){
              secondGroup.forEach((secondKey, secondValue){
                if(secondGroup.containsKey(comparisonKey) && group.length <= secondGroup.length){
                  if(secondFilterMap[mapKey] == null){secondFilterMap[mapKey] = {};}
                  secondFilterMap[mapKey].addAll(secondGroup);
                }
              });
            });
          });
        });

        var thirdFilterMap = {};

        secondFilterMap.forEach((key, group){
          var mapKey = uuid.v4();
          group.forEach((eventKey, eventValue){
            var comparisonKey = eventKey;
            secondFilterMap.forEach((key, secondGroup){
              secondGroup.forEach((secondKey, secondValue){
                if(secondGroup.containsKey(comparisonKey) && group.length <= secondGroup.length){
                  if(thirdFilterMap[mapKey] == null){thirdFilterMap[mapKey] = {};}
                  thirdFilterMap[mapKey].addAll(secondGroup);
                }
              });
            });
          });
        });

        /// Same as the other filters, but at this point it is assumed
        /// that like groups are now clones of each-other
        /// this does the same thing, but will add those groups to
        /// a map that has a shared key so that we end up
        /// with a single group from those like groups.
        var conflictingFilteredEvents = {};

        thirdFilterMap.forEach((key, group){
          group.forEach((eventKey, eventValue){
            var comparisonKey = eventKey;
            thirdFilterMap.forEach((key, secondGroup){
              secondGroup.forEach((secondKey, secondValue){
                if(secondGroup.containsKey(comparisonKey) && group.length <= secondGroup.length){

                  var listOfTimes = [];
                  var sortedEvents = {};
                  secondGroup.forEach((k, event) {
                    listOfTimes.add(event['start']);
                  });
                  listOfTimes..sort();
                  // after sorting, add events in order
                  for(var time in listOfTimes){
                    secondGroup.forEach((k,value){
                      if(time == value['start']){
                        sortedEvents.addAll({k:value});
                      }
                    });
                  }


                  List keysOfGroup = sortedEvents.keys.toList();
                  var kF = keysOfGroup.first;
                  var kL = keysOfGroup.last;
                  var firstEvent = sortedEvents[kF];
                  var lastEvent = sortedEvents[kL];
                  var firstStartValue = firstEvent['start'];
                  var lastEndValue = lastEvent['end'];
                  var dayOf = DateTime.fromMillisecondsSinceEpoch(firstStartValue).day;

                  /// Make a map key from variables above
                  var mapKey = '$dayOf,$firstStartValue,$lastEndValue';
                  if(conflictingFilteredEvents[mapKey] == null){conflictingFilteredEvents[mapKey] = {};}
                  conflictingFilteredEvents[mapKey].addAll(secondGroup);
                }
              });
            });
          });
        });
        return Stack(
          children: <Widget>[
            /// NON Conflicting EVENTS
            Stack(
                children: nonConflictingEvents.entries
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
                    ),
                  ],
                ))
                    .toList()),

            /// Conflicting EVENTS
            Stack(
                children: conflictingFilteredEvents.entries.map<Widget>((groupOfEvents)=>
                    Positioned(
                        height: getHeightByTimeConflicting(groupOfEvents, maxHeight) + (10 * groupOfEvents.value.length),
                        width: getWidthByScreenSize(context),
                        top:
                        moveBoxDownBasedOfConstraintsConflicting(groupOfEvents, maxHeight),
                        left:
                        moveBoxRightBasedOfConstraintsConflicting(groupOfEvents, maxWidth),
                        child: LayoutBuilder(builder: (context, constraints){
                          var initialHeight = getHeightByTimeConflicting(groupOfEvents, maxHeight) + (10 * groupOfEvents.value.length);
                          var initialWidth = getWidthByScreenSize(context);
                          var i = 0;
                          return InkWell(
                              onTap: (){
                                AuthLoaded auth = _authBloc.currentState;
                                conflictEventsDetailsCallBack(groupOfEvents, _eventsBloc, context, auth);
                              },
                              child:Stack(
                                  children: groupOfEvents.value.entries.map<Widget>((event) =>
                                      Positioned(
                                        height: initialHeight,
                                        top: 5.0 * i,
                                        width: initialWidth -5,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                              color: Colors.blue[900 - 100 *i++],
                                            ),
                                            child: BlocBuilder(bloc: _authBloc, builder:(context, auth){
                                              return ListView(
                                                  children: groupOfEvents.value.entries.map<Widget>((event) =>
                                                      Column(
                                                        children: <Widget>[
                                                          Container(height: 10,),
                                                          Text('${event.value['start']}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                                          Icon(Icons.arrow_downward, size: 20, color: Colors.orange,),
                                                          Text('${event.value['end']}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                                          Container(height: 10,),
                                                        ],
                                                      )
                                                  ).toList()
                                              );
                                            })
                                        ),
                                      )
                                  ).toList()
                              )
                          );
                        })
                    )
                ).toList()
            ),
          ],
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

  double moveBoxRightBasedOfConstraintsConflicting(groupOfEvents, constraints) {
    double column = constraints / 7;
    List<String> parsedKey = groupOfEvents.key.split(',');
    var sTime = DateTime.fromMillisecondsSinceEpoch(int.parse(parsedKey[1]));
    var dayInWeek = sTime.weekday;
    if (dayInWeek == 7) {
      dayInWeek = 0;
    }
    return (dayInWeek * column);
  }

  double moveBoxDownBasedOfConstraintsConflicting(groupOfEvents, constraints) {
    double height = constraints;
    double hour = height / 24;
    List<String> parsedKey = groupOfEvents.key.split(',');
    var sTime = DateTime.fromMillisecondsSinceEpoch(int.parse(parsedKey[1]));
    var hoursFromMidnight = (sTime.hour * 60 + sTime.minute) / 60;
    double distanceDown = hoursFromMidnight * hour;
    return distanceDown;
  }

  double getHeightByTimeConflicting(groupOfEvents, constraints) {
    double height = constraints;
    double hour = height / 24;
    List<String> parsedKey = groupOfEvents.key.split(',');
    var sTime = DateTime.fromMillisecondsSinceEpoch(int.parse(parsedKey[1]));
    var eTime = DateTime.fromMillisecondsSinceEpoch(int.parse(parsedKey[2]));
    var startValue = sTime.hour * 60 + sTime.minute;
    var endValue = eTime.hour * 60 + eTime.minute;
    var subtractedValue = endValue - startValue;
    double numOfHours = subtractedValue / 60;
    double result = hour * numOfHours;
    return result;
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


returnTimeInPrettyFormat(event) {
  var startTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
  var startDay = startTime.day.toString();
  var startMonth = startTime.month.toString();
  var startHour = startTime.hour.toString();
  var startMinute = ':' + startTime.minute.toString();

  var endTime = DateTime.fromMillisecondsSinceEpoch(event.value['end']);
//    var endMonth = endTime.month.toString();
  var endHour = endTime.hour.toString();
  var endMinute = ':' + endTime.minute.toString();
  var indicator = "AM";
  if (startTime.hour * 60 + startTime.minute > 720) {
    indicator = "PM";
  }

  switch (startHour) {
    case "0":
      startHour = "12";
      indicator = "AM";
      break;
    case "13":
      startHour = "1";
      indicator = "PM";
      break;
    case "14":
      startHour = "2";
      indicator = "PM";
      break;
    case "15":
      startHour = "3";
      indicator = "PM";
      break;
    case "16":
      startHour = "4";
      indicator = "PM";
      break;
    case "17":
      startHour = "5";
      indicator = "PM";
      break;
    case "18":
      startHour = "6";
      indicator = "PM";
      break;
    case "19":
      startHour = "7";
      indicator = "PM";
      break;
    case "20":
      startHour = "8";
      indicator = "PM";
      break;
    case "21":
      startHour = "9";
      indicator = "PM";
      break;
    case "22":
      startHour = "10";
      indicator = "PM";
      break;
    case "23":
      startHour = "11";
      indicator = "PM";
      break;
    case "24":
      startHour = "12";
      indicator = "AM";
      break;
  }

  switch (endHour) {
    case "13":
      endHour = "1";
      indicator = "PM";
      break;
    case "14":
      endHour = "2";
      indicator = "PM";
      break;
    case "15":
      endHour = "3";
      indicator = "PM";
      break;
    case "16":
      endHour = "4";
      indicator = "PM";
      break;
    case "17":
      endHour = "5";
      indicator = "PM";
      break;
    case "18":
      endHour = "6";
      indicator = "PM";
      break;
    case "19":
      endHour = "7";
      indicator = "PM";
      break;
    case "20":
      endHour = "8";
      indicator = "PM";
      break;
    case "21":
      endHour = "9";
      indicator = "PM";
      break;
    case "22":
      endHour = "10";
      indicator = "PM";
      break;
    case "23":
      endHour = "11";
      indicator = "PM";
      break;
    case "24":
      endHour = "12";
      indicator = "PM";
      break;
  }

  if (startMinute == ":0") {
    startMinute = "";
  }
  if (endMinute == ":0") {
    endMinute = "";
  }

  return [
    Text(
      '$startMonth/$startDay',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    Container(
      width: 20,
    ),
    Text('$startHour$startMinute$indicator - $endHour$endMinute$indicator'),
  ];
}



class CardCornerClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();

    // Draw a straight line from current point to the bottom left corner.
    path.lineTo(0.0, size.height);

    path.lineTo(size.width, size.height);

    path.lineTo(size.width, size.height * .40);

    path.lineTo(size.width *.90, 0.0);

    // Draw a straight line from current point to the top right corner.
    path.lineTo(0.0, 0.0);

    // Draws a straight line from current point to the first point of the path.
    // In this case (0, 0), since that's where the paths start by default.
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
