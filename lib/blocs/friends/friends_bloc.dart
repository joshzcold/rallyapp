import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rallyapp/blocs/friends/friends.dart';

Map<dynamic, dynamic> friends = {};

class FriendsBloc extends Bloc<FriendsEvent, Map>{

  @override
  Map get initialState => {};

  @override
  Stream<Map> mapEventToState(Map currentState, FriendsEvent event) async*{
    if(event is AddFriends){
      yield* _mapAddFriendsToState(currentState,event);
    }
  }

  Stream<Map>_mapAddFriendsToState(currentState ,event) async*{
    // TODO pass back the new event without updating currentState so a transition gets triggered
    final updatedFriends = Map.of(currentState);
    updatedFriends.addAll({event.key: event.value});
    yield updatedFriends;
  }
}



