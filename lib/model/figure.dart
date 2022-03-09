import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Figure extends StatelessWidget {

  double width, height;
  double radius;
  Color color;
  String fileName = "";

  Figure(this.width, this.height, this.radius, this.color, this.fileName);

  @override
  Widget build(BuildContext context) {
    if(fileName == "") {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
      );
    }
    else {
      return Container(
        width: width,
        height: height,
        child: Image(image: FileImage(File(fileName))),
      );
    }
  }
}
