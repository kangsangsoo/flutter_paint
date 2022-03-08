import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Line {
  Offset offset;
  Color color;

  Line(this.offset, this.color);
}

class Circle {
  Offset offset;
  Color color;
  double radius;

  Circle(this.offset, this.color, this.radius);
}

class Test extends CustomPainter {
  List<Line> linesSet;

  Test(this.linesSet);

  @override
  void paint(Canvas canvas, Size size) {

    if (linesSet.length == 0) return;

    Paint paintMountains = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..color = linesSet.first.color;

    for (var i = 0; i < linesSet.length - 1; i++) {
      canvas.drawLine(
          linesSet[i].offset, linesSet[i + 1].offset, paintMountains);
    }
    // for (var j = 0; j < linesSet.length; j++) {
    //   for (var i = 0; i < linesSet[j].length - 1; i++) {
    //     canvas.drawLine(
    //         linesSet[j][i].offset, linesSet[j][i + 1].offset, paintMountains);
    //   }
    // }

  }

  @override
  bool shouldRepaint(Test delegate) {
    return true;
  }
}

class Test1 extends CustomPainter {
  List<List<Line>> linesSet;
  List<Circle> circles;

  Test1(this.linesSet, this.circles);

  @override
  void paint(Canvas canvas, Size size) {
    if (circles.length != 0) {
      for (var j = 0; j < circles.length; j++) {
        var paint1 = Paint()
          ..color = circles[j].color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(circles[j].offset, circles[j].radius, paint1);
      }
    }


    // if (linesSet.length == 0) return;
    //
    // // for (var i = 0; i < linesSet.length - 1; i++) {
    // //   canvas.drawLine(
    // //       linesSet[i].offset, linesSet[i + 1].offset, paintMountains);
    // // }
    // print('herere');
    // for (var j = 0; j < linesSet.length; j++) {
    //   Paint paintMountains = Paint()
    //     ..strokeCap = StrokeCap.round
    //     ..strokeWidth = 5.0
    //     ..color = linesSet[j][0].color;
    //   for (var i = 0; i < linesSet[j].length - 1; i++) {
    //     canvas.drawLine(
    //         linesSet[j][i].offset, linesSet[j][i + 1].offset, paintMountains);
    //   }
    // }
  }

  @override
  bool shouldRepaint(Test1 delegate) {
    return true;
  }
}

// 캡쳐하는 방법은 지정된 범위 내에서 모든 유효한 line들만 가져오도록
