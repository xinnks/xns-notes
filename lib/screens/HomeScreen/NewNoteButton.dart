import 'package:flutter/material.dart';

Widget newNoteButton(BuildContext context) => Positioned(
  bottom: 25, right: 20.0,
  width: MediaQuery.of(context).size.width,
  child: Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/noteview');
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Color(0xFF49208F),
          textColor: Colors.white,
          hoverElevation: 9.0,
          elevation: 8.0,
          hoverColor: Color(0xFF8E32AF),
          padding: EdgeInsets.all(0.0),
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.add, size: 30.0),
          ),
        ),
      ],
    ),
  ),
);