import 'dart:convert';

import 'package:safenote/data/database.dart';
import 'package:zefyr/zefyr.dart';

class Note {
  Note({this.id, this.title, this.body, this.lastEdit, this.personId});

  Note.fromExternal({this.id, this.title, this.body, this.lastEdit, this.personId});

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        id: map['id'],
        title: map['title'],
        body: NotusDocument.fromJson(jsonDecode(map['body'])),
        lastEdit: map['last_edit'],
        personId: map['person_id']
        );
  }

  Note.newNote({this.title, this.body, this.lastEdit, this.personId});

  NotusDocument body;
  String id;
  int lastEdit;
  String personId;
  String title;

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnBody: jsonEncode(body),
      DatabaseHelper.columnLastEdit: lastEdit,
      DatabaseHelper.columnPersonId: personId
    };
  }
}
