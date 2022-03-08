import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Figure extends StatelessWidget {

  double width, height;
  double radius;
  Color color;

  Figure(this.width, this.height, this.radius, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    );
  }
}
