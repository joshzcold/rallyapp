import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/navigationBloc.dart';
import 'package:rallyapp/screens/calendarScreen.dart';
import 'package:rallyapp/screens/friendsScreen.dart';
import 'package:rallyapp/blocs/friends/friends.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('context in NavScreen $context');
    final _navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Rally')),
      body: BlocBuilder(
        bloc: _navigationBloc,
        builder: (BuildContext context, int index) {
          switch(index){
            case 0:
              return FriendsScreen();
              break;
            case 1:
              return CalendarPage();
              break;
          }
        },
      ),
      bottomNavigationBar: BlocBuilder(
        bloc: _navigationBloc,
        builder: (BuildContext context, int count){
          return BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.group), title: Text('Friends')),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), title: Text('Calendar')),
            ],
            currentIndex: count,
            fixedColor: Colors.black,
            onTap:(index){
              switch(index){
                case 0:
                  _navigationBloc.dispatch(NavigationEvent.friends);
                  break;
                case 1:
                  _navigationBloc.dispatch(NavigationEvent.calendar);
                  break;
              }
            },
          );
        }
      )
    );
  }

}


