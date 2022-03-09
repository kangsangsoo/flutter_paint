import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screen/home_screen.dart';
import './line_painter.dart';
import './resizable.dart';
import './capture.dart';
import './picker.dart';

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

  bool opacity_menu = true; // Row가 1이면 menu on, Row 0이면 off
  void toggle_menu() {
    opacity_menu = !opacity_menu;
  }


  List<Widget> paintings = <Widget>[];

  var globalKey = new GlobalKey();

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

    if (mode1 == 2) {
      return RepaintBoundary(
        key: globalKey,
        child: Stack(
          children: <Widget>[
                Container(
                    // width: width,
                    // height: height, // 다른 방법을.. 생각해보자
                    color: Colors.yellow[100])
              ] +
              paintings +
              <Widget>[
                menuBar_test(context),
              ],
        ),
      );
    } else {
      return RepaintBoundary(
        key: globalKey,
        child: Stack(
          children: <Widget>[
                Container(
                  width: width,
                  height: height, // 다른 방법을.. 생각해보자
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
              ] +
              paintings +
              [
                GestureDetector(
                  onPanStart: onPanStart,
                  onPanEnd: onPanEnd_testing,
                  onPanUpdate: onPanUpdate,
                  child: Container(
                    width: width,
                    height: height, // 다른 방법을.. 생각해보자
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
                menuBar_test(context),
              ],
        ),
      );
    }
  }

  Widget menuBar_test(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;

    if (opacity_menu) {
      return Container(
        height: 25,
        width: width,
        color: Colors.deepPurple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Container(
                // 덱스트 쓰면 벗어나던데
                color: Colors.amberAccent,
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('file')],
                  ),
                  onTap: () async {
                    String file = await fileSaver() as String;
                    print(file);
                    toggle_menu();
                    setState(() {
                    });
                    await Future.delayed(const Duration(microseconds: 1), () { // 대충 1ms
                    });
                    capture(globalKey, file);
                    toggle_menu();
                    setState(() {
                    });
                  },
                ),
              ),
            ),
            Flexible(
              flex: 4,
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
                                color: mode1 == 0 ? Colors.white : Colors
                                    .black),
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
                        children: [
                          Text(
                            'block mode',
                            style: TextStyle(
                                color: mode1 == 1 ? Colors.white : Colors
                                    .black),
                          )
                        ],
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
                        children: [
                          Text(
                            'move mode',
                            style: TextStyle(
                                color: mode1 == 2 ? Colors.white : Colors
                                    .black),
                          )
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          if (mode1 != 2) mode1 = 2;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 4,
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
                          mode1 == 0
                              ? Text(
                            'pen',
                            style: TextStyle(
                                color: mode2 == 0
                                    ? Colors.white
                                    : Colors.black),
                          )
                              : Text(
                            'circle',
                            style: TextStyle(
                                color: mode2 == 0
                                    ? Colors.white
                                    : Colors.black),
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
                          mode1 == 0
                              ? Text(
                            'eraser',
                            style: TextStyle(
                                color: mode2 == 1
                                    ? Colors.white
                                    : Colors.black),
                          )
                              : Text(
                            'rect',
                            style: TextStyle(
                                color: mode2 == 1
                                    ? Colors.white
                                    : Colors.black),
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
    else {
      return Container();
    }
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
        // circles.add(Circle(offset, Colors.black, 50));
        paintings.add(
            ResizableBox(offset, 100, 100, mode2 == 0 ? 100 : 0, Colors.red));
        print("added");
        setState(() {});
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

  void onPanEnd_testing(DragEndDetails details) {
    switch (mode1) {
      case 0:
        paintings.add(CustomPaint(
          painter: Test(lines),
        ));

        setState(() {});
        break;
      case 1:
        linesSetStreamController.add(lines); // 야매..
        break;
      default:
    }
  }
}
