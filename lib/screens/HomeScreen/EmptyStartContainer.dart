import 'package:flutter/material.dart';

Widget emptyStartContainer(BuildContext context) => Positioned(
  bottom: 200,
  width: MediaQuery.of(context).size.width,
  child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text("xns notes", style: TextStyle(fontSize: 35, color: Colors.brown, fontWeight: FontWeight.w600)),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: Text("Start creating your notes and they'll appear here.", style: TextStyle(fontSize: 20, color: Colors.brown[500])),
          ),
        ),
      ],
    ),
  ),
);