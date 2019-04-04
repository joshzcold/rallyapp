import 'package:equatable/equatable.dart';

abstract class EventsEvent extends Equatable{
  EventsEvent([List props = const []]) : super(props);
}

class AddEvents extends EventsEvent{
  final String key;
  final Map value;
  final String uid;

  AddEvents(this.uid, this.key, this.value) : super([uid, key, value]);

  @override
  String toString() => 'AddEvents { uid: $uid, key: $key, value: $value }';
}

class RemoveEvents extends EventsEvent{
  final String key;
  final String uid;

  RemoveEvents(this.uid, this.key) : super([uid, key]);

  @override
  String toString() => 'RemoveEvents { uid: $uid, key: $key}';
}

class ReplaceEventInfo extends EventsEvent{
  final String key;
  final Map value;
  final String uid;

  ReplaceEventInfo(this.key, this.value, this.uid) : super([key, value, uid]);

  @override
  String toString() => 'ReplaceEventInfo { uid: $uid, key: $key, value: $value}';
}