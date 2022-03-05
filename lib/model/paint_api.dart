import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screen/home_screen.dart';

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

  List<Circle> circles = <Circle>[];

  int mode1 = 0;
  int mode2 = 0;


  @override
  void dispose() {
    linesStreamController.close();
    linesSetStreamController.close();
  }

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
                  painter: Test1(linesSet, circles),
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
        menuBar_test(),
      ],
    );
  }

  Widget menuBar_test() {
    return Container(
      height: 25,
      color: Colors.deepPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // 덱스트 쓰면 벗어나던데
            width: 60,
            color: Colors.amberAccent,
            child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('file')],
              ),
              onTap: () {},
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              // height: 1000, // 최댓값을 주면은 Appbar를 벗어나지 못하나?
              color: Colors.blueGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'pen and eraser mode',
                          style: TextStyle(
                              color: mode1 == 0 ? Colors.white : Colors.black),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        if (mode1 != 0) {
                          mode1 = 0;
                          mode2 = 0;
                        }
                      });
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('block mode',style: TextStyle(
                          color: mode1 == 1 ? Colors.white : Colors.black),)],
                    ),
                    onTap: () {
                      setState(() {
                        if (mode1 != 1) {
                          mode1 = 1;
                          mode2 = 0;
                        }
                      });
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('move mode')],
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              // height: 1000, // 최댓값을 주면은 Appbar를 벗어나지 못하나?
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        mode1 == 0 ?
                        Text(
                          'pen',
                          style: TextStyle(
                              color: mode2 == 0 ? Colors.white : Colors.black),
                        )
                            :
                        Text(
                          'circle',
                          style: TextStyle(
                              color: mode2 == 0 ? Colors.white : Colors.black),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        if (mode2 != 0) {
                          mode2 = 0;
                        }
                      });
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        mode1 == 0 ?
                        Text(
                          'eraser',
                          style: TextStyle(
                              color: mode2 == 1 ? Colors.white : Colors.black),
                        )
                            :
                        Text(
                          'rect',
                          style: TextStyle(
                              color: mode2 == 1 ? Colors.white : Colors.black),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        if (mode2 != 1) {
                          mode2 = 1;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuBar() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            height: 30,
            color: Colors.red,
          ),
        ),
        Flexible(
          flex: 5,
          child: Container(
            height: 30,
            color: Colors.green,
          ),
        ),
        Flexible(
          flex: 5,
          child: Container(
            height: 30,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  void onPanStart(DragStartDetails details) {
    // 모드에 따라 다르게 반응해야 한다.
    switch (mode1) {
      case 0:
        lines = <Line>[];
        break;
      case 1:
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset offset = renderBox.globalToLocal(details.globalPosition);
        circles.add(Circle(offset, Colors.black, 50));
        break;
      default:
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    switch (mode1) {
      case 0:
        // 현재 좌표를 가져와야 한다.
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset offset = renderBox.globalToLocal(details.globalPosition);
        // 라인 추가
        lines.add(Line(
            offset, mode2 == 1 ? Colors.yellow[100] as Color : Colors.black));
        linesStreamController.add(Line(
            offset, mode2 == 1 ? Colors.yellow[100] as Color : Colors.black));
        break;
      case 1:
        break;
      default:
    }
  }

  void onPanEnd(DragEndDetails details) {
    switch (mode1) {
      case 0:
        // 라인 종료
        linesSet.add(lines);
        print(linesSet.length);
        linesSetStreamController.add(lines);
        break;
      case 1:
        linesSetStreamController.add(lines); // 야매..
        break;
      default:

    }
  }
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
      ..color = linesSet[0].color;

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


    if (linesSet.length == 0) return;

    // for (var i = 0; i < linesSet.length - 1; i++) {
    //   canvas.drawLine(
    //       linesSet[i].offset, linesSet[i + 1].offset, paintMountains);
    // }
    print('herere');
    for (var j = 0; j < linesSet.length; j++) {
      Paint paintMountains = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0
        ..color = linesSet[j][0].color;
      for (var i = 0; i < linesSet[j].length - 1; i++) {
        canvas.drawLine(
            linesSet[j][i].offset, linesSet[j][i + 1].offset, paintMountains);
      }
    }
  }

  @override
  bool shouldRepaint(Test1 delegate) {
    return true;
  }
}

// 캡쳐하는 방법은 지정된 범위 내에서 모든 유효한 line들만 가져오도록
