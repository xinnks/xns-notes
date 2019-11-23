import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xns_notes/services/XnsDatabase.dart';
import 'package:xns_notes/models/Note.dart';
import 'package:xns_notes/models/NoteNavigationArguments.dart';
import 'package:xns_notes/utils/UtilityMethods.dart';
// import 'package:xns_notes/screens/HomeScreen/searchContainer.dart';

import 'NewNoteButton.dart';
import 'NoteCardsContainer.dart';
import 'FoldersContainer.dart';
import 'EmptyStartContainer.dart';

class HomeScreen extends StatefulWidget {
  static const RouteName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // If no note exists show empty home screen
  bool noNotes = false;
  final XnsDatabase db = new XnsDatabase();
  final utility = new UtilityMethods();
  bool searchViewActive = false;
  String searchQuery = "";

  @override
  void initState(){
    super.initState();

    checkNotes();
  }

  checkNotes() async {
    await db.notes().then((res)=>{
      setState((){
        noNotes = (res.length < 1);
      })
    });
    // db.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wrapperWidget(context),
    );
  }

  wrapperWidget(BuildContext context) {
    // checkNotes();

    // If no added notes, show empty start screen
    if(noNotes){
      return Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  color: Colors.yellow[800],
                  image: DecorationImage(
                    image: AssetImage("assets/app_background.png"),
                    fit: BoxFit.cover,
                  )
              )
          ),
          emptyStartContainer(context),
          newNoteButton(context),
        ]
      );
    } else {
      if(!searchViewActive){ 
        return Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[800],
                    image: DecorationImage(
                      image: AssetImage("assets/app_background.png"),
                      fit: BoxFit.cover,
                    )
                )
            ),
            FoldersContainer(),
            newNoteButton(context),
            NoteCardsContainer(),
            searchContainer()
          ]
        );
      } else { // search
        return Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[800],
                    image: DecorationImage(
                      image: AssetImage("assets/app_background.png"),
                      fit: BoxFit.cover,
                    )
                )
            ),
            searchContainer(),
            searchResultsContainer(),
          ]
        );
      }
    }
  }

  Widget searchContainer() => Stack(
    children: <Widget>[
      Positioned(
        top: 25, left: 10.0, right: 10.0,
          height: 60.0,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 200, 0, .4),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [BoxShadow(color: Colors.black12,offset: Offset(1.0,0.0), blurRadius: 3.0, spreadRadius: 0.0)]
                  ),
                  child: TextField(
                    onTap: (){
                      setState((){
                        searchViewActive = true;
                      });
                    },
                    controller:  TextEditingController.fromValue(
                      searchQuery != "" ? TextEditingValue(text: searchQuery, selection: TextSelection.collapsed(offset: searchQuery.length)) : TextEditingValue(text: searchQuery)
                    ),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300, fontFamily: "Roboto", color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Notes ...',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                    onChanged: (text) async {
                      setState(() {
                        searchQuery = text;
                      });
                      if(text.length < 1){
                        setState(() {
                          searchViewActive = false;
                        });
                      } else {
                        setState(() {
                          searchViewActive = true;
                        });
                      }
                    },
                  ),
                )
              ),
            ]
          )
      ),
      searchViewActive ? Positioned(
        top: 28, right: 28.0,
        height: 60.0,
        child: InkWell(
          onTap: (){
            setState(() {
              searchQuery = "";
              searchViewActive = false;
            });
          },
          child: Container(
            height: 20.0,
            width: 20.0,
            child: Icon(Icons.cancel, size: 30, color: Color.fromRGBO(255, 255, 255, .8),),
          ),
          borderRadius: BorderRadius.circular(10.0),
        )
      ) : Positioned( top: 28, right: 0.0, child: Container(),),
    ],
  );

  Widget searchResultsContainer() => Positioned(
    top: 60, left: 10.0, right: 10.0,bottom: 5,
      child: Consumer<XnsDatabase>(
        builder: (context, db, child){
          return FutureBuilder(
            future: db.searchForNote(searchQuery),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i){
                    return searchResultsListItem(context, snapshot.data[i]);
                  },
                );
              } else {
                return Container();
              }
            },
          );
        },
      )
  );

  Widget searchResultsListItem(BuildContext context, Note note) => Row(
    children: <Widget>[
      Expanded(
        child: InkWell(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 50.0,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(top: 2.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text("${note.title}", style: TextStyle(fontSize: 20.0, color: Color(0xFF49208F)),),),
              ],
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, .9),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/noteview', arguments: NoteNavigationArguments(note));
          },
        ),
      ),
      Container(
        width: 20.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: utility.getColor("${note.color}"),
           borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        ),
      ),
    ],
  );
}