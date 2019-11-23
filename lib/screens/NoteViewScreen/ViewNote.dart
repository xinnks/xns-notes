import 'package:flutter/material.dart';
import 'package:xns_notes/services/XnsDatabase.dart';
import 'package:xns_notes/models/Folder.dart';
import 'package:xns_notes/models/Note.dart';
import 'package:xns_notes/utils/UtilityMethods.dart';

class ViewNote extends StatefulWidget {

  final Note noteNavData;

  ViewNote(this.noteNavData);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {

  Note noteData;
  String _selectedFolder;
  List<Folder> _folders;
  List<DropdownMenuItem> folderDropdownItems;
  List<DropdownMenuItem> colorsDropdownItems;
  String _title = "";
  String _content = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String _color;
  int _folderId;
  Color _colorCol;
  final XnsDatabase db = new XnsDatabase();
  final utility = new UtilityMethods();
  var titleTxt = TextEditingController(), contentTxt = TextEditingController();
  List<String> colorsList;

  @override
  initState() {
    colorsList = utility.colors;
    _folderId = widget.noteNavData.folderId;
    initData();
    colorsDropdownItems = populateColorsDropdown(colorsList);
    super.initState();

  }

  Future<Note> getNoteData(id) async {
    return await db.fetchNote(id);
  }

  initData() async {
    await fetchFolders();
    await getNoteData(widget.noteNavData.id).then((res) => {
      setState((){
        noteData = res;
        _title = res.title;
        titleController.text = res.title;
        _content = res.content;
        contentController.text = res.title;
        _color = res.color;
        _colorCol = utility.getColor(_color);
      })
    });
  }

  fetchFolders() async {
    return await db.folders().then((res) => {
      setState((){
        _folders = res;
        _selectedFolder = getSelectedFolder(widget.noteNavData.folderId);
        print("NOTE's FOLDER ID AT BEGINING - ${widget.noteNavData.folderId}");
        print("SELECTED FOLDER AT BEGINING - $_selectedFolder");
        folderDropdownItems = formulateFolderDropdownItems(res);
      })
    });
  }

  formulateFolderDropdownItems(List<Folder> folder){
    List<DropdownMenuItem> drops = <DropdownMenuItem>[];
    if(folder.length > 0){
      folder.forEach((f){
        drops.add(
          DropdownMenuItem(
            value: f.id,
            child: Container(
              height: 40.0,
              width: 60.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("${f.name}", style: TextStyle(fontSize: 16, color: _folderId == f.id ? Color(0xFF6538AA) : Colors.black, fontWeight: FontWeight.w500),),
                  )
                ],
              ),
            ),
          )  
        );
      });
    }
    return drops;
  }

  populateColorsDropdown(List<String> colors){
    List<DropdownMenuItem> colorDrops = <DropdownMenuItem>[];
    if(colors.length > 0){
      colors.forEach((col){
        colorDrops.add(
          DropdownMenuItem(
            value: "$col",
            child: Container(
              height: 40.0,
              width: 40.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: utility.getColor("$col"),
                        borderRadius: BorderRadius.circular(20.0),
                      )
                    )
                  )
                ],
              ),
            ),
          )  
        );
      });
    }
    return colorDrops;
  }

  getSelectedFolder(folderId){
    String folderName = "";
    for(Folder f in _folders){
      if(f.id == folderId){
        folderName = f.name;
      }
    }
    return folderName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Center(
            child: Icon(Icons.arrow_back_ios, color: Colors.black,),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: _colorCol,
        toolbarOpacity: 0.5,
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DropdownButton(
                elevation: 1,
                underline: Container(
                  height: 0.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent
                  ),
                ),
                items: colorsDropdownItems,
                onChanged: (value){
                  setState((){
                    _color = "$value";
                    _colorCol = utility.getColor(value);
                  });
                },
                hint: Container(
                  height: 35.0,
                  width: 35.0,
                  decoration: BoxDecoration(
                    color: _colorCol,
                    border: Border.all(color: Colors.white, width: 3.0),
                    borderRadius: BorderRadius.circular(17.5)
                  )
                ),
              ),
              DropdownButton(
                elevation: 1,
                underline: Container(
                  height: 0.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent
                  ),
                ),
                items: folderDropdownItems,
                onChanged: (value){
                  setState((){
                    _folderId = value;
                    _selectedFolder = getSelectedFolder(value);
                  });
                  fetchFolders();
                },
                hint: Container(
                  height: 40.0,
                  width: 40,
                  child: Icon(Icons.folder, size: 40, color: Color(0xFF49208F),),
                ),
              ),
            ]
          ),
          SizedBox(width: 10.0,
            child: Center(
              child: Container(
                height: 30.0,
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.white54, width: 1.5))
                ),
              ),
            ),
          ),
          InkWell(
            child: Center(child: Icon(Icons.delete_forever, size: 30.0, color: Colors.black,)),
            onTap: () {
              _showDeleteDialog(context);
            },
          ),
          SizedBox(width: 10.0,),
          InkWell(
            child: Center(child: Icon(Icons.save_alt, size: 30.0, color: Colors.black,)),
            onTap: () async {
              if(_title != "" && _content != "" && _color != "" && !_folderId.isNaN){
                final Note newNote = Note(id: noteData.id, title: "$_title", content: "$_content", color: "$_color", folderId: _folderId);
                await db.updateNote(newNote).then((res) => {
                  Navigator.pushNamed(context, '/')
                });
              }
            },
          ),
          SizedBox(width: 10.0,),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: _colorCol,
            )
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, .4),
            )
          ),
          Positioned(
            top: 5.0, left: 10, right: 10,
              height: 60.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextField(
                        controller: TextEditingController.fromValue(
                          _title != "" ? TextEditingValue(text: _title, selection: TextSelection.collapsed(offset: _title.length)) : TextEditingValue(text: _title)
                        ),
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, fontFamily: "Roboto"),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: _title != "" ? _title : 'Title',
                          contentPadding: EdgeInsets.only(left: 10)
                        ),
                        onChanged: (text) {
                          setState((){
                            titleController.text = text;
                            _title = text;
                          });
                        },
                      ),
                    )
                  ),
                ]
              )
          ),
          Positioned(
            top: 75, left: 10, right: 10, bottom: 10,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: TextEditingController.fromValue(
                        _content != "" ? TextEditingValue(text: _content, selection: TextSelection.collapsed(offset: _content.length)) : TextEditingValue(text: _content)
                      ),
                      minLines: ((MediaQuery.of(context).size.height - 200) ~/ 30).toInt(),
                      maxLines: ((MediaQuery.of(context).size.height - 200) ~/ 25).toInt(),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, fontFamily: "Roboto"),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _content,
                        contentPadding: EdgeInsets.only(left: 10)
                      ),
                      onChanged: (text) {
                        setState((){
                          _content = text;
                        });
                      },
                    )
                  )
                ),
              ]
            )
          ),
        ]
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
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
                    child: Text("Delete Note?", style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
          ),
          content: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 60.0,
                  width: 150.0,
                  padding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                  margin: EdgeInsets.only(left: 22.0, right: 22.0),
                  child: Text("Delete This Note?"),
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("No", style: TextStyle(color: Color(0xFF49208F))),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: new Text("Yes", style: TextStyle(color: Color(0xFF49208F))),
              onPressed: () async {
                await db.deleteNote(noteData.id);
                Navigator.pushNamed(context, '/');
              }
            )
          ]
        );
      }
    );
  }
}