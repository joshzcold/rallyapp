import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/blocs/date_week/date_week.dart';

var currentHour = new DateTime.now().hour;

List<int> timeHour = [
  24,
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
List<int> columns = [1, 2, 3, 4, 5, 6, 7, 8];

class Week extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dateWeekBloc = BlocProvider.of<DateWeekBloc>(context);
    print('current hour: $currentHour');
    return BlocBuilder(bloc: dateWeekBloc,
    builder: (BuildContext context, currentWeek){
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            // You can change up this value later to increase or decrease the height
            // of the week grid.
            double maxHeightWanted = viewportConstraints.maxHeight + 800;
            double maxPossibleWidth = viewportConstraints.maxWidth;
            return SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: viewportConstraints.minHeight,
                        maxHeight: maxHeightWanted,
                        minWidth: viewportConstraints.minWidth,
                        maxWidth: maxPossibleWidth),
                    child: Stack(
                      children: <Widget>[
                        Row(
                            children: columns
                                .map(
                                  (columns) => Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  color: Color(0xFFdadce0),
                                                  width: 1))),
                                      child: Column(
                                          children: timeHour
                                              .map((hour) => Expanded(
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
                                              .toList()))),
                            )
                                .toList()),
                        eventCards(context, maxHeightWanted, maxPossibleWidth, currentWeek),
                      ],
                    )));
          });
    });
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

  double moveBoxDownBasedOfConstraints(MapEntry event, constraints) {
    double height = constraints;
    double hour = height / 24;
    var sTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
    var hoursFromMidnight = (sTime.hour * 60 + sTime.minute) / 60;
    double distanceDown = hoursFromMidnight * hour;
    return distanceDown;
  }

  double moveBoxRightBasedOfConstraints(MapEntry event, constraints) {
    double column = constraints / 8;
    var sTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
    var dayInWeek = sTime.weekday + 1;
    if (dayInWeek == 8) {
      dayInWeek = 1;
    }
    return (dayInWeek * column);
  }

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
          .map<Widget>((friend) => Container(
              width: 15.0,
              height: 15.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(friend.value['userPhoto'])))))
          .toList();
    } else {
      return <Widget>[Container()];
    }
  }

  eventCards(context, maxHeight, maxWidth, currentWeek) {
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(
        bloc: _eventsBloc,
        builder: (BuildContext context, state) {
          Map<dynamic, dynamic> newDict = {};
            state.events.entries.forEach((item) => {
                  item.value.forEach((key, value){
                    int sTime = value['start'];
                    DateTime startWeek = currentWeek.week.first.subtract(Duration(hours: 6));
                    DateTime endWeek = currentWeek.week.last.add(Duration(hours: 18)).subtract(Duration(minutes: 1));
                    //TODO set start week and end week to the limits of the week
                        if(sTime >= startWeek.millisecondsSinceEpoch && sTime <= endWeek.millisecondsSinceEpoch){
                          newDict.addAll({key: value});
                        }
                      })
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
                              child: FlatButton(
                                clipBehavior: Clip.hardEdge,
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                onPressed: () {
                                  print('clicked on $event');
                                },
                                child: ListView(
                                  padding: EdgeInsets.all(0),
                                  children: <Widget>[
                                    // User Image
                                    Container(
                                        width: 30.0,
                                        height: 33.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new NetworkImage(event
                                                    .value['userPhoto'])))),
                                    // User Name & Description
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${event.value['userName']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text: '${event.value['title']}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            height: getHeightByTime(event, maxHeight) + 100,
                            width: 20,
                            top:
                                moveBoxDownBasedOfConstraints(event, maxHeight),
                            left: moveBoxRightBasedOfConstraints(
                                    event, maxWidth) -
                                10,
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
}
