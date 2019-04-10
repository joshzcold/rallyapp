

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
  try {
    final file = await _localFile;

    // Read the file
    Config config = new Config.fromStrings(file.readAsLinesSync());

    return config;

  } catch (e) {

    return e;
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/rally.ini');
}