import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Line {
  Offset offset;

  Line(this.offset);
}

class PaintApi extends StatefulWidget {
  @override
  _PaintApiState createState() => _PaintApiState();
}

class _PaintApiState extends State<PaintApi> {
  List<Line> lines = <Line>[];
  List<List<Line>> linesSet = <List<Line>>[];
  StreamController<Line> linesStreamController =
      StreamController<Line>.broadcast();
  StreamController<List<Line>> linesSetStreamController =
      StreamController<List<Line>>.broadcast();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Stack(
      children: [
        Container(
          width: width,
          height: height - 30, // 다른 방법을.. 생각해보자
          color: Colors.yellow[100],
          child: RepaintBoundary(
            child: StreamBuilder<List<Line>>(
              stream: linesSetStreamController.stream,
              builder: (context, snapshot) {
                return CustomPaint(
                  painter: Test1(linesSet),
                );
              },
            ),
          ),
        ),
        GestureDetector(
          onPanStart: onPanStart,
          onPanEnd: onPanEnd,
          onPanUpdate: onPanUpdate,
          child: Container(
            width: width,
            height: height - 30, // 다른 방법을.. 생각해보자
            color: Colors.transparent,
            child: RepaintBoundary(
              child: StreamBuilder<Line>(
                stream: linesStreamController.stream,
                builder: (context, snapshot) {
                  return CustomPaint(
                    painter: Test(lines),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onPanStart(DragStartDetails details) {
    lines = <Line>[];
  }

  void onPanUpdate(DragUpdateDetails details) {
    // 현재 좌표를 가져와야 한다.
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.globalToLocal(details.globalPosition);
    // 라인 추가
    lines.add(Line(offset));
    linesStreamController.add(Line(offset));
  }

  void onPanEnd(DragEndDetails details) {
    // 라인 종료
    linesSet.add(lines);
    print(linesSet.length);
    linesSetStreamController.add(lines);
  }
}

class Test extends CustomPainter {
  List<Line> linesSet;

  Test(this.linesSet);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintMountains = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..color = Colors.brown;

    if (linesSet.length == 0) return;
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

  Test1(this.linesSet);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintMountains = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..color = Colors.brown;

    if (linesSet.length == 0) return;

    // for (var i = 0; i < linesSet.length - 1; i++) {
    //   canvas.drawLine(
    //       linesSet[i].offset, linesSet[i + 1].offset, paintMountains);
    // }
    print('herere');
    for (var j = 0; j < linesSet.length; j++) {
      for (var i = 0; i < linesSet[j].length - 1; i++) {
        canvas.drawLine(
            linesSet[j][i].offset, linesSet[j][i + 1].offset, paintMountains);
      }
    }
  }

  @override
  bool shouldRepaint(Test delegate) {
    return true;
  }
}

// 캡쳐하는 방법은 지정된 범위 내에서 모든 유효한 line들만 가져오도록
