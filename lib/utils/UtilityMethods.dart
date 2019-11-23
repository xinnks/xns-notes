import 'package:flutter/material.dart';

class UtilityMethods {

  List<String> noteColors = [
    "grey"
    "red",
    "green",
    "blue",
    "yellow",
  ];

  get colors => noteColors;

  getColor(color) {
    switch(color){
      case 'red':
      return Colors.redAccent;
      case 'blue':
      return Colors.blueAccent;
      case 'green':
      return Colors.greenAccent;
      case 'amber':
      return Colors.amberAccent;
      default:
      return Colors.blueGrey;
    }
  }
}