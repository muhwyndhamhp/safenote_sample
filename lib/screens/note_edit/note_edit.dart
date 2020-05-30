import 'package:flutter/material.dart';
import 'package:safenote/data/database.dart';
import 'package:safenote/models/note.dart';
import 'package:zefyr/zefyr.dart';
import 'package:notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';

class NoteEdit extends StatefulWidget {
  NoteEdit({this.note, this.filename = "", this.uuid});

  final dbHelper = DatabaseHelper.instance;
  final String filename;
  final Note note;
  final String uuid;

  @override
  State<StatefulWidget> createState() => NoteEditPageState();
}

class NoteEditPageState extends State<NoteEdit> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    if (widget.note.id != null) {
      setState(() {
        _controller = ZefyrController(widget.note.body);
      });
    } else {
      setState(() {
        _controller = ZefyrController(NotusDocument.fromDelta(
            Delta()..insert("Enter your note here! \n")));
      });
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return true;
  }

  void _saveDocument(
      BuildContext context, ZefyrController _controller, int lastEdit) {
    if (widget.note.id != null) {
      var newerNote = widget.note;
      newerNote.body = _controller.document;
      newerNote.lastEdit = lastEdit;
      widget.dbHelper.update(newerNote).then((_) =>_onWillPop());
    } else {
      var newNote = Note.newNote(
          title: "Another Note",
          body: _controller.document,
          lastEdit: lastEdit,
          personId: widget.dbHelper.getUuid());
      widget.dbHelper.saveNote(newNote, true).then((_) => _onWillPop());
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Saved!"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Note Editor"),
            actions: <Widget>[
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () => _saveDocument(context, _controller,
                      DateTime.now().millisecondsSinceEpoch),
                ),
              )
            ],
          ),
          body: ZefyrScaffold(
            child: ZefyrEditor(
                padding: EdgeInsets.all(16),
                controller: _controller,
                focusNode: _focusNode),
          ),
        ),
        onWillPop: _onWillPop);
  }
}
