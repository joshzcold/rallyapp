
import 'package:scoped_model/scoped_model.dart';

var isLoading = false;

class StateModel extends Model{

  Future<void> toggleLoading() async{
    isLoading = !isLoading;
  }

}