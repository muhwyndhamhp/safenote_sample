import 'package:flutter/material.dart';
import 'screens/note_lists/note_lists.dart';
import 'screens/note_edit/note_edit.dart';

const NoteListsRoute = '/';
const NoteEditRoute = '/note_edit';

class App extends StatelessWidget {
  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case NoteListsRoute:
          screen = NoteLists();
          break;
        case NoteEditRoute:
          screen = NoteEdit(note: arguments['note'], filename: arguments['fileName'], uuid: arguments['uuid'],);
          break;
        default:
        return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: _routes(),);
  }
}