import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';

var currentHour = new DateTime.now().hour;

List<int> timeHour = [
  24,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23
];
List<int> days = [1,2,3,4,5,6,7];

class Week extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    print('current hour: $currentHour');
    return Stack(
      children: <Widget>[
    SingleChildScrollView(
    child:Table(
        children: timeHour.map((hour) => TableRow(
        children: days.map((day) => Container(
          decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5, color: Colors.grey),
                left: BorderSide(width: 0.5, color: Colors.grey),
                right: BorderSide(width: 0.5, color: Colors.grey),
                bottom: BorderSide(width: 0.5, color: Colors.grey),
              )
          ),
          height: 60,
          child: Center(
            child: Text('$hour'),
          ),
        )).toList()
    )).toList(),
    ),
    ),
      EventCards(),
      ],
    );
  }
}

class EventCards extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(bloc: _eventsBloc, builder: (BuildContext context, state){
      return Stack(
        children: state.events.entries.map((user)=>
            user.value.entries.map<Widget>((event) =>
            FractionallySizedBox(
          heightFactor: getHeightByTime(event),
          widthFactor: getWidthByScreenSize(context),
          child: Card(
            child: FlatButton(onPressed: (){
              print('clicked on $event');
            }, child: Text('$event')),
          ),
        )).toList()).toList()
      );
    });
  }

  double getHeightByTime(event){
    print('${event.value}');
    return 0.20;
  }

  double getWidthByScreenSize(context){
    double width = MediaQuery.of(context).size.width;
    double weekWidth = width/7;
    double reducedWidth = weekWidth - 0;
    double percentage = reducedWidth/width;
    return percentage;
  }
  
}