import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rallyapp/blocs/friends/friends.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState>{

  @override
  FriendsState get initialState => FriendsLoading();

  @override
  Stream<FriendsState> mapEventToState(FriendsState currentState, FriendsEvent event) async*{
    if(event is AddFriends){
      yield* _mapAddFriendsToState(currentState,event);
    } else if(event is RemoveFriends){
      yield* _mapRemoveFriendsToState(currentState, event);
    } else if(event is ReplaceFriendInfo){
      yield* _mapReplaceFriendDetailToState(currentState, event);
    } else if(event is ClearFriends){
      yield* _mapClearFriendsToState(currentState);
    }else if (event is ManualDoneLoadingFriends) {
      yield* _mapManualDoneLoading(currentState);
    }
  }

  Stream<FriendsState>_mapAddFriendsToState(currentState ,event) async*{
    if(currentState is FriendsLoading){
      currentState = {};
      currentState[event.key] = {};
    } else if(currentState is FriendsLoaded){
      currentState = currentState.friends;
      currentState[event.key] ={};
    }
    final updatedFriends = Map.of(currentState);
    updatedFriends[event.key] = event.value;
    yield FriendsLoaded(updatedFriends);
  }

  Stream<FriendsState>_mapRemoveFriendsToState(currentState ,event) async*{
    if(currentState is FriendsLoading){
      currentState = {};
    } else if(currentState is FriendsLoaded){
      currentState = currentState.friends;
    }
    final updatedFriends = Map.of(currentState);
    updatedFriends.remove(event.key);
    yield FriendsLoaded(updatedFriends);
  }

  Stream<FriendsState>_mapReplaceFriendDetailToState(currentState ,event) async*{
    if(currentState is FriendsLoading){
      currentState = {};
    } else if(currentState is FriendsLoaded){
      currentState = currentState.friends;
    }
    final updatedFriends = Map.of(currentState);
    updatedFriends[event.uid].update(event.key, (dynamic val) => event.value);
    yield FriendsLoaded(updatedFriends);
  }

  Stream<FriendsState>_mapClearFriendsToState(currentState) async*{
    currentState = {};
    yield FriendsLoading();
  }

  Stream<FriendsState>_mapManualDoneLoading(currentState) async*{
    if(currentState is FriendsLoading){
      yield FriendsLoaded({});
    } else if(currentState is FriendsLoaded){
      yield FriendsLoaded(currentState.friends);
    }
  }
}
