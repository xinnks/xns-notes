import 'package:flutter/material.dart';
import 'package:xns_notes/Objects/ScreenNavigationArguments.dart';

class NoteViewScreen extends StatefulWidget {
  static const RouteName = '/noteview';

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenNavigationArguments args = ModalRoute.of(context).settings.arguments;
    
    return Scaffold();
  }
}
