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

