import 'package:equatable/equatable.dart';

abstract class FriendsEvent extends Equatable{
  FriendsEvent([List props = const []]) : super(props);
}

class AddFriends extends FriendsEvent{
  final String key;
  final Map value;

  AddFriends(this.key, this.value) : super([key, value]);

  @override
  String toString() => 'AddFriends { key: $key, value: $value }';
}

class RemoveFriends extends FriendsEvent{
  final String key;

  RemoveFriends(this.key) : super([key]);

  @override
  String toString() => 'RemoveFriends { key: $key}';
}

class ReplaceFriendInfo extends FriendsEvent{
  final String key;
  final String value;
  final String uid;

  ReplaceFriendInfo(this.key, this.value, this.uid) : super([key, value, uid]);

  @override
  String toString() => 'RemoveFriends { uid: $uid, key: $key, value: $value}';
}

class ClearFriends extends FriendsEvent{
  @override
  String toString() => 'ClearFriends';
}

