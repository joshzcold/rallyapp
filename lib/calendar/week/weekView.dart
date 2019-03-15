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
    return  LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
            constraints: BoxConstraints(
            minHeight: viewportConstraints.minHeight,
            maxHeight: viewportConstraints.maxHeight + 1024
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
                                          color: Colors.grey, width: 0.5))),
                              child: Column(
                                  children: timeHour
                                      .map((hour) => Expanded(child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.5))),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              child: Center(
                                                child: Text(
                                                  '$columns : $hour',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ))
                                        ],
                                      ))))
                                      .toList()))),
                    ).toList()),
                eventCards(context),
              ],
            )));
      }
    );
  }

  double getHeightByTime(event) {
    print('event value ${event.value}');
    var sTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
    var eTime = DateTime.fromMillisecondsSinceEpoch(event.value['end']);
    var startValue = sTime.hour * 60 + sTime.minute;
    var endValue = eTime.hour * 60 + eTime.minute;
    var subtractedValue = endValue - startValue;
    var percentage = subtractedValue / 1440;
    return percentage;
  }

  double getWidthByScreenSize(context) {
    double width = MediaQuery.of(context).size.width;
    double weekWidth = width / 8;
    double reducedWidth = weekWidth - 0;
    double percentage = reducedWidth / width;
    return percentage;
  }

  eventCards(context) {
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
          return  Stack(
                  children: newDict.entries.map<Widget>((event) =>
                      FractionallySizedBox(
                        heightFactor: getHeightByTime(event),
                        widthFactor: getWidthByScreenSize(context),
                        child: Card(
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
