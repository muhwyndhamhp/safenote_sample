import 'dart:math';

import 'package:flutter/material.dart';
import 'package:safenote/models/note.dart';
import 'package:zefyr/zefyr.dart';

import 'note_lists.dart';

const colors = [0xaa264653, 0xff2a9d8f, 0xffe9c46a, 0xfff4a261, 0xffe76f51];

Widget generateNoteElement(BuildContext context, Note note) {
  Random random = Random();
  return ConstrainedBox(
    constraints: BoxConstraints(maxHeight: 350),
    child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              decoration: BoxDecoration(
                color: Color(colors[random.nextInt(5)]),
              ),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2.5),
              padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    note.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.5),
                  ),
                  ZefyrView(document: note.body)
                ],
              ))
        ])),
  );
}
