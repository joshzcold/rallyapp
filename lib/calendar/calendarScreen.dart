import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/calendar/week/weekView.dart';


class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EventsBloc _eventsBloc = BlocProvider.of<EventsBloc>(context);

    return Scaffold(
      appBar: PreferredSize(child: AppBar(
        backgroundColor: Colors.white,
      ), preferredSize: Size.fromHeight(50)),
          body: BlocBuilder(
          bloc: _eventsBloc,
          builder: (BuildContext context, state) {
            if (state is EventsLoading) {
              print('EventsLoading...');
//              return Calendar();
              return new Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is EventsLoaded) {
              return Calendar();
            }
          }),
      floatingActionButton:
      Container(
        child: FloatingActionButton(
            onPressed: (){},
            backgroundColor: Colors.blue,
            child: Icon(Icons.add)
        ),
      ),
    );
  }
}

