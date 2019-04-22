import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState>{

  @override
  InviteState get initialState => InvitesNotLoaded();

  @override
  Stream<InviteState> mapEventToState(InviteState currentState, InviteEvent event) async*{
    if(event is AddInvite){
      yield* _mapAddInviteToState(currentState,event);
    } else if (event is RemoveInvite){
      yield* _mapRemoveInviteToState(currentState, event);
    }
  }

  Stream<InviteState>_mapAddInviteToState(currentState ,event) async*{
    if(currentState is InvitesNotLoaded){
      currentState = {};
      currentState[event.key] = {};
    } else if(currentState is InvitesLoaded){
      currentState = currentState.invites;
      currentState[event.key] ={};
    }
    final updatedInvites = Map.of(currentState);
    updatedInvites[event.key] = event.value;
    yield InvitesLoaded(updatedInvites);
  }
  Stream<InviteState>_mapRemoveInviteToState(currentState ,event) async*{
    if(currentState is InvitesNotLoaded){
      currentState = {};
    } else if(currentState is InvitesLoaded){
      currentState = currentState.invites;
    }
    final updatedInvite = Map.of(currentState);
    updatedInvite.remove(event.key);
    yield InvitesLoaded(updatedInvite);
  }

}


abstract class InviteEvent extends Equatable{
  InviteEvent([List props = const []]) : super(props);
}

class AddInvite extends InviteEvent{
  String key;
  Map value;


  AddInvite(this.key, this.value) : super([key, value]);

  @override
  String toString() => 'AddInvite { key: $key, value: $value}';
}

class RemoveInvite extends InviteEvent{
  String key;


  RemoveInvite(this.key) : super([key]);

  @override
  String toString() => 'RemoveInvite { key: $key}';
}


abstract class InviteState extends Equatable {
  InviteState([List props = const []]) : super(props);
}

class InvitesLoaded extends InviteState {
  final invites;

  InvitesLoaded([this.invites = const []]) : super([invites]);
  @override
  String toString() => 'InvitesLoaded {invites: $invites}';
}

class InvitesNotLoaded extends InviteState {

  @override
  String toString() => 'InvitesNotLoaded {}';
}
