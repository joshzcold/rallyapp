import 'package:scoped_model/scoped_model.dart';

class AuthModel extends Model{
  var _user ={};

  void setUser(user){
  _user = user;
  notifyListeners();
  print('user has been set to $user');
  }

  void clearUser(){
    _user = {};
    notifyListeners();
    print('user has been cleared');
  }
}