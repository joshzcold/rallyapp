import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable{
  AuthState([List props = const[]]) : super(props);
}

class AuthLoading extends AuthState{
  @override
  String toString() => 'AuthLoading';
}

class AuthLoaded extends AuthState{
  final Map user;

  AuthLoaded(this.user);

  @override
  String toString() => 'AuthLoaded { user: $user}';
}

class AuthNotLoaded extends AuthState{
  @override
  String toString() => 'AuthNotLoaded';
}