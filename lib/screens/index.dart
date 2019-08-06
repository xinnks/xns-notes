import 'package:flutter/material.dart';

import 'FolderScreen/index.dart';
import 'HomeScreen/index.dart';
import 'NoteViewScreen/index.dart';

class App extends StatefulWidget {
  final Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => HomeScreen(),
    FolderScreen.RouteName: (context) => FolderScreen(),
    NoteViewScreen.RouteName: (context) => NoteViewScreen(),
  };

  @override
  State<StatefulWidget> createState() {
    return null;
  }
}
