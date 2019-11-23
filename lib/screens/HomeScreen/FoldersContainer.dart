import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xns_notes/services/XnsDatabase.dart';
import 'package:xns_notes/models/Folder.dart';
import 'package:xns_notes/models/FolderNavigationArguments.dart';

class FoldersContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Positioned(
      top: 230, bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 150.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Text("Folders", style: TextStyle(fontSize: 23.0, color: Colors.black),),
              AddFolderButton(),
            ]),
            SizedBox(height: 2.0),
            Container(
              height: (MediaQuery.of(context).size.height - (125+250+30+4+30)).floor().toDouble(),
              child: Consumer<XnsDatabase>(
                builder: (context, db, child){
                  return FutureBuilder(
                    future: db.folders(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i){
                            return folderListItem(context, snapshot.data[i]);
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget folderListItem(BuildContext context, Folder folder) => Row(
    children: <Widget>[
      Expanded(
        child: InkWell(
          child: Container(
            padding: EdgeInsets.only(top: 3.0, bottom: 1.0),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[Text("${folder.name}", style: TextStyle(fontSize: 20.0, color: Colors.brown[700]),)]),
                SizedBox(height: 5.0),
                Row(children: <Widget>[Text("${folder.notesCount} notes", style: TextStyle(fontSize: 17.0, color: Colors.brown[500]),)]),
              ],
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[400], width: 1.0, style: BorderStyle.solid))
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/folder', arguments: FolderNavigationArguments(folder));
          },
        ),
      ),
    ],
  );

}

// add folder button
class AddFolderButton extends StatefulWidget {

  @override
  AddFolderButtonState createState() => AddFolderButtonState();
}

class AddFolderButtonState extends State<AddFolderButton> {

  XnsDatabase _db = XnsDatabase();
  String folderName = "";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _addFolder(context);
      },
      focusColor: Colors.red,
      highlightColor: Colors.blue,
      hoverColor: Colors.green,
      splashColor: Colors.yellow,
      child: Container(
        margin: EdgeInsets.only(left: 5.0),
        height: 30.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 200, 0, 1),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }

  void _addFolder(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          titlePadding: EdgeInsets.all(0.0),
          title: Container(
            height: 50.0,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0.0, left: 0.0, right: 0.0, bottom: 0.0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                    decoration: BoxDecoration(color: Color(0xFF49208F)),
                    child: Text("Add Folder", style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
          ),
          content: Container(
            height: 50.0,
            width: 150.0,
            padding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
            margin: EdgeInsets.only(left: 22.0, right: 22.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF49208F), width: 1.0))
            ),
            child: TextField(
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: "Roboto"),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Folder Name..',
                contentPadding: EdgeInsets.only(left: 10)
              ),
              onChanged: (text) {
                setState((){
                  folderName = text;
                });
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("Cancel", style: TextStyle(color: Color(0xFF49208F))),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: new Text("Add", style: TextStyle(color: Color(0xFF49208F))),
              onPressed: () async {
                if(folderName != ""){
                  await _db.createFolder(Folder(name: folderName));
                  Navigator.of(context).pop();
                }
              }
            )
          ]
        );
      }
    );
  }
}