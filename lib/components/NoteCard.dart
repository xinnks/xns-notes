import 'package:flutter/material.dart';
import 'package:xns_notes/models/Note.dart';
import 'package:xns_notes/models/NoteNavigationArguments.dart';
import 'package:xns_notes/utils/UtilityMethods.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final bool gridChild;

  NoteCard({this.note, this.gridChild = false});
  

  @override
  NoteCardState createState() => NoteCardState();
}

class NoteCardState extends State<NoteCard> {

  Note noteData;
  bool childOfGrid;
  final utility = new UtilityMethods();

  @override
  void initState() {
    noteData = widget.note;
    childOfGrid = widget.gridChild;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/noteview', arguments: NoteNavigationArguments(noteData));
        },
        child: Container(
          height: 220.0,
          width: 200.0,
          padding: MediaQuery.of(context).size.width > 300 ? EdgeInsets.all(20.0) : EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [BoxShadow(color: Colors.black12,offset: Offset(1.0,1.0), blurRadius: 5.0, spreadRadius: 0.0)]
          ),
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[ 
                Expanded(
                  child: Container(
                    height: 50.0,
                    child: Text("${noteData.title}", style: TextStyle(fontSize: ((MediaQuery.of(context).size.width / 100).floor() * 6).toDouble(), color: utility.getColor(noteData.color))),
                  ),
                )
              ]),
              SizedBox(height: 10.0,),
              Row(children: <Widget>[ 
                Expanded(
                  child: Container(
                    height: childOfGrid ? 30.0 : 90.0,
                    child: Text("${noteData.content}", style: TextStyle(fontSize: ((MediaQuery.of(context).size.width / 100).floor() * 4).toDouble())),
                  ),
                )
              ]),
              SizedBox(height: 10.0,),
              Row(children: <Widget>[ 
                Expanded(
                  child: Container(
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: utility.getColor(noteData.color),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                  ),
                )
              ]),
            ],
          ),
        )
      ),
    );
  }
}