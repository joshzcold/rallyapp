import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rallyapp/blocs/friends/friends.dart';

Map<dynamic, dynamic> friends = {};

class FriendsBloc extends Bloc<FriendsEvent, FriendsState>{
  @override get initialState => FriendsLoading();

  @override
  Stream<FriendsState> mapEventToState(FriendsState currentState, FriendsEvent event) async*{
    if(event is AddFriends){
      yield* _mapAddFriendsToState(currentState, event);
    }
  }

  Stream<FriendsState> _mapAddFriendsToState(
      FriendsState currentState,
      AddFriends event,
      ) async* {
    friends.addAll({event.key: event.value});
    yield FriendsLoaded(friends: friends);
  }
}



