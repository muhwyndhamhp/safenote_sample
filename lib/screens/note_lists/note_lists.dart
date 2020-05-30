import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:safenote/app.dart';
import 'package:safenote/data/database.dart';
import 'package:safenote/data/network.dart';
import 'package:safenote/models/note.dart';
import 'package:zefyr/zefyr.dart';

import 'note_element.dart';

class NoteLists extends StatefulWidget {
  final dbHelper = DatabaseHelper.instance;

  @override
  State<StatefulWidget> createState() => NoteListsPageState();
}

class NoteListsPageState extends State<NoteLists> {
  Future<List<Note>> _loadAllNotes() async {
    List<Note> noteList = await widget.dbHelper.getAllNotes();
    return noteList;
  }

  ///Floating Action Button builder, this buttons do routing to NoteEdit for creating new note.
  Widget _floatingActionButtonNewNote(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, NoteEditRoute,
            arguments: {'note': new Note()}).then((value) => setState(() {}));
      },
      child: Icon(Icons.edit),
      backgroundColor: Colors.green,
    );
  }

  ///Futue builder for the whole UI.
  ///This is required as the note lists is needed to be retrieved from database first before shown to user
  Widget _futureItemBuilder(BuildContext context) {
    return FutureBuilder(
      future: _loadAllNotes(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Note>> noteListSnapshot) {
        ///if the data is yet to be retrieved
        if (noteListSnapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(child: Text('Loading Notes...')),
          );
        } else {
          ///if the retrieving process returns Error
          if (noteListSnapshot.hasError) {
            return Container(
              child: Center(child: Text('Failed to load Notes!')),
            );

            //if all is well
          } else {
            List<Note> list1 = List<Note>();
            List<Note> list2 = List<Note>();

            for (var i = 0; i < noteListSnapshot.data.length; i++) {
              if (i % 2 == 0)
                list1.add(noteListSnapshot.data[i]);
              else
                list2.add(noteListSnapshot.data[i]);
            }

            if (list1.length > 1 && list2.length > 1) {
              if (list1.length > list2.length) {
                list2.add(list1[list1.length - 1]);
                list1.removeLast();
              } else {
                list1.add(list2[list2.length - 1]);
                list2.removeLast();
              }
            }
            return _scaffoldBuilder(context, list1, list2, noteListSnapshot);
          }
        }
      },
    );
  }

  ///Builder for scaffold after List of notes is retrieved fom database
  Widget _scaffoldBuilder(BuildContext context, List<Note> list1,
      List<Note> list2, AsyncSnapshot<List<Note>> noteListSnapshot) {
    return ZefyrScaffold(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2.5),
                child: Column(
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                                  children: []..addAll(
                                      _noteElementIterator(context, list1)))),
                          Expanded(
                              child: Column(
                                  children: []..addAll(
                                      _noteElementIterator(context, list2)))),
                        ]),
                    IconButton(
                        onPressed: () {
                          uploadAllData(noteListSnapshot.data);
                        },
                        icon: Icon(Icons.cloud_upload))
                  ],
                ))));
  }

  /// iterator for converting Note model to ZefyrView Widget via generateNoteElement
  List<Widget> _noteElementIterator(BuildContext context, List<Note> list) {
    return list
        .map((e) => GestureDetector(
            onTap: () => _onItemTap(e), child: generateNoteElement(context, e)))
        .toList();
  }

  ///function on tapping the Note Widget on sceen
  _onItemTap(Note note) {
    Navigator.pushNamed(context, NoteEditRoute, arguments: {'note': note})
        .then((value) => setState(() {}));
  }

//Build Method, just for entry points. Other code placed on _futureItemBuilder
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note List"),
      ),
      body: _futureItemBuilder(context),
      floatingActionButton: _floatingActionButtonNewNote(context),
    );
  }
}
