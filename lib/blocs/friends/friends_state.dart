import 'package:equatable/equatable.dart';

abstract class FriendsState extends Equatable {
  FriendsState([List props = const []]) : super(props);
}

class FriendsLoaded extends FriendsState {
  final friends;

  FriendsLoaded(this.friends) : super([friends]);

  @override
  String toString() => 'FriendsLoaded { friends: $friends }';
}
