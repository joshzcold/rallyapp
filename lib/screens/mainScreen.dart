import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/model/navigationBloc.dart';
import 'package:rallyapp/screens/calendarScreen.dart';
import 'package:rallyapp/screens/friendsScreen.dart';


class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final NavigationBloc _navigationBloc = NavigationBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: BlocProvider<NavigationBloc>(
        bloc: _navigationBloc,
        child: CounterPage(),
      ),
    );
  }

  @override
  void dispose() {
    _navigationBloc.dispose();
    super.dispose();
  }
}


class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NavigationBloc _navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Rally')),
      body: BlocBuilder<NavigationEvent, int>(
        bloc: _navigationBloc,
        builder: (BuildContext context, int index) {
          switch(index){
            case 0:
              return FriendsScreen();
              break;
            case 1:
              return CalendarScreen();
              break;
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationEvent, int>(
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


