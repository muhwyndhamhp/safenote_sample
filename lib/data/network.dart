import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:safenote/models/note.dart';

var baseUrl = "https://api.airtable.com/v0/appzr3RwEqjmGHxW6/Notes";

const String api_key = "ENTER YOUR API KEY HERE";

Future<List<Note>> fetchNotes(String personId) async {
  var httpResponse = await http.get(
      baseUrl +
          "?" +
          "filterByFormula=" +
          // "%7B" +
          "person_id" +
          // "%7B" +
          "%3D" +
          "%22" +
          personId +
          // "5697b1e7-09d5-4244-b346-478e75e85612" +
          "%22",
      headers: {HttpHeaders.authorizationHeader: api_key});

  if (httpResponse.statusCode == HttpStatus.ok) {
    var result = jsonDecode(httpResponse.body);
    var records = result['records'];

    var noteList = List<Note>();
    for (var record in records) {
      noteList.add(Note.fromMap(record['fields']));
    }
    return noteList;
  }
  return null;
}

Future<bool> uploadAllData(List<Note> noteList) async {
  List<List<Note>> listOfListNote = List<List<Note>>();
  for (var i = 0; i < noteList.length; i += 5) {
    var end = (i + 5 < noteList.length) ? i + 5 : noteList.length;
    listOfListNote.add(noteList.sublist(i, end));
  }

  for (var listOfNote in listOfListNote) {
    String bodyText = "";

    for (var note in listOfNote) {
      if (note == listOfNote.last) {
        bodyText += '{"fields": ${jsonEncode(note.toMap())}}';
      } else {
        bodyText += '{"fields": ${jsonEncode(note.toMap())}},';
      }
    }

    var httpResponse = await http.post(baseUrl,
        headers: {
          HttpHeaders.authorizationHeader: api_key,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: '{"records": [' + bodyText + ']}');
    if (httpResponse.statusCode != HttpStatus.ok) return false;
  }
  return true;
}

Future<String> uploadSingleNote(Note note) async {
  var httpResponse = await http.post(baseUrl,
      headers: {
        HttpHeaders.authorizationHeader: api_key,
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: '{"records": [{"fields": ${jsonEncode(note.toMap())}}]}');

  var results = jsonDecode(httpResponse.body)['records'];
  var record = results[0];
  var id = record['id'];
  return id;
}

Future<String> updateSingleNote(Note note) async {
  var body =
      '{"records": [{"id": "${note.id}", "fields": ${jsonEncode(note.toMap())}}]}';
  var httpResponse = await http.patch(baseUrl,
      headers: {
        HttpHeaders.authorizationHeader: api_key,
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: body);

  var results = jsonDecode(httpResponse.body)['records'];
  var record = results[0];
  var id = record['id'];
  return id;
}
