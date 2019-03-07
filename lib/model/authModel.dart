import 'package:scoped_model/scoped_model.dart';

var userRally ={};

class AuthModel extends Model{

  void setUser(user){
    userRally = user;
    print('user has been set to $userRally');
    notifyListeners();
  }

  void clearUser(){
    userRally.clear();
    notifyListeners();
    print('user has been cleared');
  }

  void replaceValue(key, value){
    userRally.update(key, (dynamic val) => value);
    print('change this info in user: $key : $value');
    print('what is user? : $userRally');
  }
}