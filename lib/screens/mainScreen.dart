import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/model/navigationBloc.dart';


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
      appBar: AppBar(title: Text('Counter')),
      body: BlocBuilder<NavigationEvent, int>(
        bloc: _navigationBloc,
        builder: (BuildContext context, int count) {
          return Center(
            child: Text(
              '$count',
              style: TextStyle(fontSize: 24.0),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationEvent, int>(
        bloc: _navigationBloc,
        builder: (BuildContext context, int count){
          return BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.group), title: Text('Friends')),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), title: Text('Calendar')),
              BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), title: Text('Somethig Else')),
            ],
            currentIndex: count,
            fixedColor: Colors.deepPurple,
            onTap:(index){
              switch(index){
                case 0:
                  _navigationBloc.dispatch(NavigationEvent.friends);
                  break;
                case 1:
                  _navigationBloc.dispatch(NavigationEvent.calendar);
                  break;
                case 2:
                  _navigationBloc.dispatch(NavigationEvent.somethingElse);
                  break;
              }
            },
          );
        }
      )
    );
  }

}


