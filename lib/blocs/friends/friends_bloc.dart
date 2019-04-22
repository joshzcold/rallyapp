import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rallyapp/blocs/friends/friends.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState>{

  @override
  FriendsState get initialState => FriendsLoaded({});

  @override
  Stream<FriendsState> mapEventToState(FriendsState currentState, FriendsEvent event) async*{
    if(event is AddFriends){
      yield* _mapAddFriendsToState(currentState,event);
    } else if(event is RemoveFriends){
      yield* _mapRemoveFriendsToState(currentState, event);
    } else if(event is ReplaceFriendInfo){
      yield* _mapReplaceFriendDetailToState(currentState, event);
    }
  }

  Stream<FriendsState>_mapAddFriendsToState(currentState ,event) async*{
    final updatedFriends = Map.of(currentState.friends);
    updatedFriends[event.key] = event.value;
    yield FriendsLoaded(updatedFriends);
  }

  Stream<FriendsState>_mapRemoveFriendsToState(currentState ,event) async*{
    final updatedFriends = Map.of(currentState.friends);
    updatedFriends.remove(event.key);
    yield FriendsLoaded(updatedFriends);
  }

  Stream<FriendsState>_mapReplaceFriendDetailToState(currentState ,event) async*{
    final updatedFriends = Map.of(currentState.friends);
    updatedFriends[event.uid].remove(event.key);
    updatedFriends[event.uid].addAll({event.key: event.value});
    yield FriendsLoaded(updatedFriends);
  }

}
