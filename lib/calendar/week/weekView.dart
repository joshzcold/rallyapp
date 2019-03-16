import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';

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
    print('current hour: $currentHour');
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
                  maxWidth: maxPossibleWidth
              ),
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
                  eventCards(context, maxHeightWanted, maxPossibleWidth),
                ],
              )));
    });
  }

  double getHeightByTime(event, constraints) {
    double height = constraints;
    double hour = height/24;
    var sTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
    var eTime = DateTime.fromMillisecondsSinceEpoch(event.value['end']);
    var startValue = sTime.hour * 60 + sTime.minute;
    var endValue = eTime.hour * 60 + eTime.minute;
    var subtractedValue = endValue - startValue;
    double numOfHours = subtractedValue/60;
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
    double hour = height/24;
    var sTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
    var hoursFromMidnight = (sTime.hour*60 + sTime.minute)/60;
    double distanceDown = hoursFromMidnight*hour;
    return distanceDown;
  }

  double moveBoxRightBasedOfConstraints(MapEntry event, constraints) {
    double column = constraints/8;
    var sTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
    var dayInWeek = sTime.weekday + 1;
    if(dayInWeek == 8){dayInWeek = 1;}
    return (dayInWeek * column);
  }

  eventCards(context, maxHeight, maxWidth) {
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(
        bloc: _eventsBloc,
        builder: (BuildContext context, state) {
          Map<dynamic, dynamic> newDict = {};
          state.events.entries.forEach((item) => {
                item.value.forEach((key, value) => {
                      newDict.addAll({key: value})
                    })
              });
          return Stack(
              children: newDict.entries
                  .map<Widget>((event) => Positioned(
                        height: getHeightByTime(event, maxHeight),
                        width: getWidthByScreenSize(context),
                        top: moveBoxDownBasedOfConstraints(event, maxHeight),
                        left: moveBoxRightBasedOfConstraints(event, maxWidth),
                        child: Card(
                          color: Colors.blue,
                          child: FlatButton(
                              onPressed: () {
                                print('clicked on $event');
                              },
                              child: Text('EVENT')),
                        ),
                      ))
                  .toList());
        });
  }


}
