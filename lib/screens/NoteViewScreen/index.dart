import 'package:flutter/material.dart';
import 'package:xns_notes/models/NoteNavigationArguments.dart';
import 'package:xns_notes/screens/NoteViewScreen/NewNote.dart';
import 'package:xns_notes/screens/NoteViewScreen/ViewNote.dart';

class NoteViewScreen extends StatefulWidget {
  static const RouteName = '/noteview';
  final NoteNavigationArguments navArguments;

  NoteViewScreen(this.navArguments);

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    build(context);
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: initNoteView(widget.navArguments),
    );
  }

  initNoteView(NoteNavigationArguments navArguments) {
    if(widget.navArguments != null){ // Read / Edit
      return ViewNote(navArguments.note);
    } else { // New Note
      return NewNote();
    }
  }
}
