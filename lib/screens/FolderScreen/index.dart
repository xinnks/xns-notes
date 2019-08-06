import 'package:flutter/material.dart';
import 'package:xns_notes/Objects/ScreenNavigationArguments.dart';

class FolderScreen extends StatefulWidget {
  static const RouteName = '/folder';

  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenNavigationArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold();
  }
}
