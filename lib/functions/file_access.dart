import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';

Future<String> _localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

void saveUuid(String uuid) async {
  final path = await _localPath();

  final file = File(path + "/" + "uuid.json");
  file.writeAsString(jsonEncode(uuid));
}

Future<String> getUuidFromFile() async {
  final _path = await _localPath();
  final file = File(_path + "/" + "uuid.json");
  if (await file.exists()) {
    return jsonDecode(await file.readAsString());
  }
  return null;
}

///TOTALLY UNUSED CODE, ARTIFACT FROM EARLIER BUILDS!!
///here to stay as sample how to do (and don't) File IO with local storage..

Future<List<String>> loadNoteList() async {
  final _path = await _localPath();
  final file = File(_path + "/" + "note_list.json");
  if (await file.exists()) {
    return List<String>.from(jsonDecode(await file.readAsString()));
  }

  final contents = jsonEncode(["123456"]);
  final file2 = File(_path + "/" + "note_list.json");
  file2.writeAsString(contents);
  return ["123456"];
}

Future<NotusDocument> loadDocument(String _fileName) async {
  final _path = await _localPath();
  final file = File(_path + "/" + _fileName + ".json");
  if (await file.exists()) {
    final contents = await file.readAsString();
    return NotusDocument.fromJson(jsonDecode(contents));
  }
  final Delta delta = Delta()..insert("File not found!\n");
  return NotusDocument.fromDelta(delta);
}

void saveDocument(
    BuildContext context, ZefyrController _controller, String _fileName) async {
  final contents = jsonEncode(_controller.document);

  final path = await _localPath();

  final file = File(path + "/" + _fileName + ".json");
  file.writeAsString(contents);

  final file2 = File(path + "/" + "note_list.json");
  List<String> noteTitleList =
      List<String>.from(jsonDecode(await file2.readAsString()));
  noteTitleList.add(_fileName);

  final encodedNoteTitleList = jsonEncode(noteTitleList);

  final file3 = File(path + "/" + "note_list.json");
  file3.writeAsString(encodedNoteTitleList);

  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text("Saved!"),
  ));
}
