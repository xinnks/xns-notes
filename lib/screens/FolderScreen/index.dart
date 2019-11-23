import 'package:flutter/material.dart';
import 'package:xns_notes/components/NoteCard.dart';
import 'package:xns_notes/services/XnsDatabase.dart';
import 'package:xns_notes/models/Folder.dart';
import 'package:xns_notes/models/FolderNavigationArguments.dart';
import 'package:xns_notes/models/Note.dart';

class FolderScreen extends StatefulWidget {
  static const RouteName = '/folder';
  final FolderNavigationArguments navArguments;

  FolderScreen(this.navArguments);

  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  String _folderName;
  Folder _folderData;
  List<Note> _folderNotes = <Note>[];
  XnsDatabase _db = XnsDatabase();

  @override
  void initState() {
    super.initState();

    setFolderName(widget.navArguments.folder);
    getFolderData(widget.navArguments.folder);
  }
  
  getFolderData(Folder folder) async {
    await _db.notesByFolder(folder.id).then((res) => {
      setState(() {
        _folderNotes = res;
      })
    });
  }

  setFolderName(Folder folder){
    setState(() {
      _folderName = folder.name;
      _folderData = folder;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Center(
            child: Icon(Icons.arrow_back_ios, color: Colors.white,),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("$_folderName"),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              _deleteFolder();
            },
            child: Icon(
                Icons.delete_sweep,
                size: 30.0,
                color: Colors.white,
              ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 5, bottom: 5, left: 5, right: 5,
            child: _folderNotes.length > 0 ? GridView.builder(
              itemCount: _folderNotes.length,
              itemBuilder: (context, i){
                return NoteCard(note: _folderNotes[i]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.8,
                crossAxisCount: 2,
              ),
            ) : Center(
              child: Text("No Notes", style: TextStyle(fontSize: 24.0),),
            ),
          )
        ],
      )
    );
  }

  void _deleteFolder(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Delete ${_folderData.name}?"),
          content: Text("Delete folder '${_folderData.name}' and all it's notes?"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            FlatButton(
              onPressed: () async {
                await _db.deleteFolder(_folderData.id);
                Navigator.pushNamed(context, '/');
              },
              child: Text("Yes"),
            ),
          ],
        );
      }
    );
  }
}
