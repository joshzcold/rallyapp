

import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> readConf() async {
  try {
    final file = await _localFile;

    // Read the file
    String contents = await file.readAsString();

    return contents;

  } catch (e) {
    // If encountering an error, return 0
    return "";
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/rally.conf');
}