import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class NotifyBloc extends Bloc<NotifyEvent, NotifyState>{

  @override
  NotifyState get initialState => NotifysLoaded({});

  @override
  Stream<NotifyState> mapEventToState(NotifyState currentState, NotifyEvent event) async*{
    if(event is AddNotify){
      yield* _mapAddNotifyToState(currentState,event);
    } else if (event is ChangeNotify){
      yield* _mapReplaceNotifyToState(currentState, event);
    }
  }

  Stream<NotifyState>_mapAddNotifyToState(currentState ,event) async*{
   if(currentState is NotifysLoaded){
      currentState = currentState.notify;
      currentState[event.key] ={};
    }
    final updatedNotifys = Map.of(currentState);
    updatedNotifys[event.key] = event.value;
    yield NotifysLoaded(updatedNotifys);
  }
  Stream<NotifyState>_mapReplaceNotifyToState(currentState ,event) async*{
    final updatedNotify = Map.of(currentState.notify);
    updatedNotify.remove(event.key);
    updatedNotify.addAll({event.key: event.value});
    yield NotifysLoaded(updatedNotify);
  }

}


abstract class NotifyEvent extends Equatable{
  NotifyEvent([List props = const []]) : super(props);
}

class AddNotify extends NotifyEvent{
  String key;
  Map value;


  AddNotify(this.key, this.value) : super([key, value]);

  @override
  String toString() => 'AddNotify { key: $key, value: $value}';
}

class ChangeNotify extends NotifyEvent{
  String key;
  Map value;


  ChangeNotify(this.key, this.value) : super([key, value]);

  @override
  String toString() => 'ChangeNotify { key: $key, value: $value}';
}


abstract class NotifyState extends Equatable {
  NotifyState([List props = const []]) : super(props);
}

class NotifysLoaded extends NotifyState {
  final notify;

  NotifysLoaded([this.notify = const []]) : super([notify]);
  @override
  String toString() => 'NotifysLoaded {notify: $notify}';
}

class NotifysNotLoaded extends NotifyState {

  @override
  String toString() => 'NotifysNotLoaded {}';
}
