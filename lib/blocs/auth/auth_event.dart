import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable{
  AuthEvent([List props = const[]]) : super(props);
}

class AddAuth extends AuthEvent{
  final Map value;
  final String key;

  AddAuth(this.key, this.value) : super([key,value]);

  @override
  String toString() => 'AddAuth {key: $key, value: $value}';

}

class RemoveAuth extends AuthEvent{
  @override
  String toString() => 'RemoveAuth';
}

class ReplaceAuthInfo extends AuthEvent{
  final String key;
  final String uid;
  final String value;

  ReplaceAuthInfo(this.uid, this.key, this.value) : super([uid, key, value]);

  @override
  String toString() => 'ReplaceAuthInfo { uid: $uid ,key: $key, value: $value}';
}