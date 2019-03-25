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
    if(currentState is AuthLoading){
      currentState = {};
    } else if(currentState is AuthLoaded){
      currentState = currentState;
    }
    var updatedAuth = {event.key:event.value};
    yield AuthLoaded(event.key, event.value);
  }

  Stream<AuthState> _mapRemoveAuthToState( currentState,  event) async*{
    if(currentState is AuthLoading){
      currentState = {};
    } else if(currentState is AuthLoaded){
      currentState = currentState.user;
    }
    final updatedAuth = Map.of(currentState);
    updatedAuth.remove(event.key);
    yield AuthLoading();
  }

  // TODO remove Internal Linked Hash Map from this update statement
  Stream<AuthState> _mapReplaceAuthInfoToState( currentState,  event) async*{
    if(currentState is AuthLoading){
      currentState = {};
    } else if(currentState is AuthLoaded){
      currentState = currentState.user;
    }
    final updatedAuth = Map.of(currentState);
    updatedAuth[event.uid].update(event.key, (dynamic val) => event.value);
    yield AuthLoaded(event.key, event.value);
  }
}


//  void setUser(user){
//    userRally = user;
//    print('user has been set to $userRally');
//  }
//
//  void clearUser(){
//    userRally.clear();
//    print('user has been cleared');
//  }
//
//  void replaceValue(key, value){
//    userRally.update(key, (dynamic val) => value);
//    print('change this info in user: $key : $value');
//    print('what is user? : $userRally');
//  }