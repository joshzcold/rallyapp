import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable{
  AuthState([List props = const[]]) : super(props);

}

class AuthLoading extends AuthState{
  @override
  String toString() => 'AuthLoading';
}

class AuthLoaded extends AuthState{
  final Map value;
  final String key;

  AuthLoaded(this.key, this.value);

  @override
  String toString() => 'AuthLoaded{key: $key, value: $value}';
}

class AuthNotLoaded extends AuthState{
  @override
  String toString() => 'AuthNotLoaded';
}