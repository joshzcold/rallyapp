import 'package:scoped_model/scoped_model.dart';

class AuthModel extends Model{
  var _user ={};

  void setUser(user){
  _user = user;
  notifyListeners();
  }

  void clearUser(){
    _user = {};
    notifyListeners();
  }
}