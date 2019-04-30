

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:ini/ini.dart';
Future<String> writeToConf(contents) async{
  try{
    final file = await _localFile;
    file.writeAsString(contents.toString());
    return "success";
  } catch(e){
    return e;
  }
}

readConf() async {
  var result;
  try {
    var file = await _localFile;
    Config config = Config.fromStrings(file.readAsLinesSync());
    result = config;
  } catch (e) {
    if(e is FileSystemException){
      result = Config.fromString("");
    }
  }
  return result;
}


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/rally.ini');
}