import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/screens/login.dart';
import 'package:rallyapp/screens/settings.dart';
import 'package:rallyapp/screens/mainScreen.dart';
import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:rallyapp/blocs/navigationBloc.dart';
import 'package:rallyapp/blocs/eventBloc.dart';
import 'package:rallyapp/screens/friendsScreen.dart';


void main() {
runApp(Rally());
}

class Rally extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders:[
        BlocProvider<FriendsBloc>(bloc: FriendsBloc()),
        BlocProvider<NavigationBloc>(bloc: NavigationBloc()),
        BlocProvider<CounterBloc>(bloc: CounterBloc()),
      ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Rally',
          initialRoute: '/',
          routes: {
            '/': (context) => SignInPage(),
            '/main': (context) => MainScreen(),
            '/settings': (context) => Settings(),
          },
        )
    );
  }
}











