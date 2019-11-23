import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xns_notes/models/Note.dart';
import 'package:xns_notes/components/NoteCard.dart';
import 'package:xns_notes/services/XnsDatabase.dart';

class NoteCardsContainer extends StatefulWidget {

  @override
  _NoteCardsContainerState createState() => _NoteCardsContainerState();
}

class _NoteCardsContainerState extends State<NoteCardsContainer> {

  List<Note> _notes = <Note>[];
  final db = new XnsDatabase();
  
  @override
  void initState() {
    super.initState();

    checkNotes();
  }

  checkNotes() async {
    await db.notes().then((res) => {
      setState((){
        _notes = res;
      })
    });
    // db.close();
  }

  @override
  Widget build(BuildContext context) {
    // checkNotes();

    return Positioned(
      top: 90.0, left: 0.0, right: 0.0,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text("Recent Notes", style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.w400)),
              )
            ],
          ),
          Container(
            height: 250.0,
            child: Stack(
              children: <Widget>[
                Consumer<XnsDatabase>(
                  builder: (context, db, child){
                    return FutureBuilder(
                      future: db.notes(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _notes.length,
                            itemBuilder: (context, i) {
                              final note = _notes[i];
                              return NoteCard(note: note);
                            }
                          );
                        } else {
                          return Center();
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
