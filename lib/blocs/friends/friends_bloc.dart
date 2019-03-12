import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rallyapp/blocs/friends/friends.dart';

Map<dynamic, dynamic> friends = {};

class FriendsBloc extends Bloc<FriendsEvent, FriendsState>{

  @override
  FriendsState get initialState => FriendsLoading();

  @override
  Stream<FriendsState> mapEventToState(FriendsState currentState, FriendsEvent event) async*{
    if(event is AddFriends){
      yield* _mapAddFriendsToState(currentState,event);
    }
  }

  Stream<FriendsState>_mapAddFriendsToState(currentState ,event) async*{
    if(currentState is FriendsLoading){
      currentState = {};
    } else if(currentState is FriendsLoaded){
      currentState = currentState.friends;
    }
    final updatedFriends = Map.of(currentState);
    updatedFriends.addAll({event.key: event.value});
    yield FriendsLoaded(updatedFriends);
  }
}
