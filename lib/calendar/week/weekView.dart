import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:sticky_headers/sticky_headers.dart';

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

List<int> columns = [1, 2, 3, 4, 5, 6, 7];


 calendar(BuildContext context, day){

    return LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            // You can change up this value later to increase or decrease the height
            // of the week grid.
            // If you change the +800 after maxHeightWanted, change that value in
            // the parent widget as well.
            double maxHeightWanted = MediaQuery
                .of(context)
                .size
                .height + 800;
            double maxPossibleWidth = viewportConstraints.maxWidth;
            return StickyHeader(
              header: new Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  new BoxShadow(
                    color: Colors.grey[500],
                    blurRadius: 5.0,
                  )
                ]),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:Center(child:calculateDayStyle(day, maxPossibleWidth)),

                      ),
                  ],
                ),
              ),
              content: Container(
                height: maxHeightWanted,
                child: Stack(
                  children: <Widget>[
                    Column(
                        children: timeHour
                            .map((hour) =>
                            Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                        right: BorderSide(
                                        color: Color(
                  0xFFdadce0),
                width: 1),
                                            bottom: BorderSide(
                                                color: Color(
                                                    0xFFdadce0),
                                                width: 1))),
                                    child: Row(
                                      children: <Widget>[
                                        Container()
                                      ],
                                    ))))
                            .toList()),
                    eventCards(context, maxHeightWanted, maxPossibleWidth, day),
                    currentTimeIndicator(context, maxHeightWanted, day)
                  ],
                ),
              ),
            );
          });
}

currentTimeIndicator(BuildContext context, double maxHeightWanted,day) {
  DateTime cday = DateTime.now();
  String value = day.year.toString() + day.month.toString() + day.day.toString();
  String today = cday.year.toString() + cday.month.toString() + cday.day.toString();
    if (today == value) {
      return Stack(
        children: <Widget>[
          Positioned(
            top: moveIndicatorDownBasedOfConstraints(cday, maxHeightWanted) -
                10,
            left: 0,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                Container(
                  color: Colors.green,
                  width: 50,
                  height: 3,
                ),
              ],
            ),
          )
        ],
      );
    } else{
      return Container();
    }
}

double moveIndicatorDownBasedOfConstraints(sTime, constraints) {
  double height = constraints;
  double hour = height / 24;
  var hoursFromMidnight = (sTime.hour * 60 + sTime.minute) / 60;
  double distanceDown = hoursFromMidnight * hour;
  return distanceDown;
}

  calculateDayStyle(DateTime day, width) {
    DateTime cday = DateTime.now();
    String value = day.year.toString() + day.month.toString() + day.day.toString();
    String today = cday.year.toString() + cday.month.toString() + cday.day.toString();
    if (value == today) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 150, 150, 150),
        ),
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
        child: new Text(
          "${day.day}",
          style: TextStyle(color: Colors.grey, fontSize: 20.0),
        ),
        alignment: FractionalOffset(0.5, 0.5),
      );
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

  eventCards(context, maxHeight, maxWidth, day) {
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(
        bloc: _eventsBloc,
        builder: (BuildContext context, state) {
          Map<dynamic, dynamic> newDict = {};
          state.events.entries.forEach((item) => {
                item.value.forEach((key, value) {
                  int sTime = value['start'];
                  DateTime startWeek =
                      day.subtract(Duration(hours: 6));
                  DateTime endWeek = day
                      .add(Duration(hours: 18))
                      .subtract(Duration(minutes: 1));
                  if (sTime >= startWeek.millisecondsSinceEpoch &&
                      sTime <= endWeek.millisecondsSinceEpoch) {
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


class ClipLeftMostColumn extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    var columnIncrement = (size.width / 8) / 1.3;

    // Draw a straight line from current point to the bottom left corner.
    path.lineTo(columnIncrement, size.height);

    // Draw a straight line from current point to the top right corner.
    path.lineTo(size.width, size.height);

    path.lineTo(size.width, 0.0);

    path.lineTo(columnIncrement, 0.0);

    path.lineTo(columnIncrement, size.height);

//  path.lineTo(0.0, 0.0);

    // Draws a straight line from current point to the first point of the path.
    // In this case (0, 0), since that's where the paths start by default.
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
