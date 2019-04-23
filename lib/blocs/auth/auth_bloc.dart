import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rallyapp/blocs/auth/auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{

  @override
  AuthState get initialState => AuthLoading();

  @override
  Stream<AuthState> mapEventToState(AuthState currentState, AuthEvent event) async*{
    if(event is AddAuth){
      yield* _mapAddAuthToState(currentState, event);
    } else if(event is RemoveAuth){
      yield* _mapRemoveAuthToState(currentState, event);
    } else if(event is ReplaceAuthInfo){
      yield* _mapReplaceAuthInfoToState(currentState, event);
    }

  }

  Stream<AuthState> _mapAddAuthToState(currentState,event) async*{
    yield AuthLoaded(event.key, event.value);
  }

  Stream<AuthState> _mapRemoveAuthToState( currentState,  event) async*{
    yield AuthLoaded("",{});
  }

  Stream<AuthState> _mapReplaceAuthInfoToState(currentState,  event) async*{
    var updatedAuth = Map.of(currentState.value);
    updatedAuth[event.key] = event.value;

    yield AuthLoaded(currentState.key, updatedAuth);
  }
}
