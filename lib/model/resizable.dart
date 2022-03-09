import 'dart:async';

import 'package:flutter/material.dart';
import './figure.dart';

const int LEFT = 8;
const int TOP = 4;
const int RIGHT = 2;
const int BOTTOM = 1;
const List<int> DIRECTION_LIST = <int>[
  LEFT,
  TOP,
  RIGHT,
  BOTTOM,
  LEFT + TOP,
  LEFT + BOTTOM,
  RIGHT + TOP,
  RIGHT + BOTTOM
];
const double NEMO_SIZE = 10;

class ResizableBox extends StatefulWidget {
  Offset offset;
  double width, height;
  double radius;
  Color color;
  String fileName;

  ResizableBox(this.offset, this.width, this.height, this.radius, this.color, this.fileName);

  @override
  ResizableState createState() =>
      ResizableState(offset, width, height, radius, color, fileName);
}

class ResizableState extends State<ResizableBox> {
  Offset offset;
  double width, height;
  double radius;
  Color color;
  String fileName = "";
  static bool isMovemode = false;
  static StreamController<bool> boolStreamController =
      StreamController<bool>.broadcast();

  static bool toggle_isMovemode() {
    return isMovemode = !isMovemode;
  }

  static StreamController<bool> getStreamController() {
    return boolStreamController;
  }

  ResizableState(this.offset, this.width, this.height, this.radius, this.color, this.fileName);

  void callback(double deltaWidth, double deltaHeight, int direction) {
    setState(() {
      Offset tmpOffset = offset;
      switch (direction) {
        case LEFT:
          width = width - deltaWidth;
          offset = offset + Offset(deltaWidth, deltaHeight);
          break;
        case TOP:
          height = height - deltaHeight;
          offset = offset + Offset(deltaWidth, deltaHeight);
          break;
        case RIGHT:
          width = width + deltaWidth;
          break;
        case BOTTOM:
          height = height + deltaHeight;
          break;
        case LEFT + TOP:
          width = width - deltaWidth;
          height = height - deltaHeight;
          offset = offset + Offset(deltaWidth, deltaHeight);
          break;
        case LEFT + BOTTOM:
          width = width - deltaWidth;
          height = height + deltaHeight;
          offset = offset + Offset(deltaWidth, 0);
          break;
        case RIGHT + TOP:
          width = width + deltaWidth;
          height = height - deltaHeight;
          offset = offset + Offset(0, deltaHeight);
          break;
        case RIGHT + BOTTOM:
          print(deltaHeight);
          print(deltaWidth);
          width = width + deltaWidth;
          height = height + deltaHeight;
          break;
        default:
          break;
      }
      if (width < 0) {
        width = 0;
        offset = tmpOffset;
      }
      if (height < 0) {
        height = 0;
        offset = tmpOffset;
      }
    });
  }

  List<Positioned> createBtn() {
    List<Positioned> btns = <Positioned>[];
    for (int i = 0; i < DIRECTION_LIST.length; i++) {
      double left = 0, top = 0;

      switch (DIRECTION_LIST[i]) {
        case LEFT:
          left = 0;
          top = height / 2;
          break;
        case TOP:
          left = width / 2;
          top = 0;
          break;
        case RIGHT:
          left = width;
          top = height / 2;
          break;
        case BOTTOM:
          left = width / 2;
          top = height;
          break;
        case LEFT + TOP:
          left = 0;
          top = 0;
          break;
        case LEFT + BOTTOM:
          left = 0;
          top = height;
          break;
        case RIGHT + TOP:
          left = width;
          top = 0;
          break;
        case RIGHT + BOTTOM:
          left = width;
          top = height;
          break;
        default:
          break;
      }

      btns.add(Positioned(
        top: offset.dy + top - NEMO_SIZE / 2,
        left: offset.dx + left - NEMO_SIZE / 2,
        child: ResizableBtn(
          callback,
          DIRECTION_LIST[i],
        ),
      ));
    }

    return btns;
  }



  @override
  Widget build(BuildContext context) {
    // move mode일 때만 보이게 하고 싶다.

    return Container(
        child: StreamBuilder<bool>(
            stream: boolStreamController.stream,
            builder: (context, snapshot) {
              if (isMovemode != true) {
                return Positioned(
                  top: offset.dy,
                  left: offset.dx,
                  // 여기에 들어가야 함.
                  child: Figure(width, height, radius, color, fileName),
                );
              } else {
                return Stack(
                  children: [
                        // 눈에 보여지는 박스가 제일 아래에 오도록
                        Positioned(
                          top: offset.dy,
                          left: offset.dx,
                          child: GestureDetector(
                            // 여기가 이제 사각형이냐 동그라미냐
                            child: Figure(width, height, radius, color, fileName),
                            // child: Container(
                            //   width: width,
                            //   height: height,
                            //   color: Colors.red,
                            // ),
                            onPanUpdate: (DragUpdateDetails details) {
                              setState(() {
                                offset = Offset(details.delta.dx + offset.dx,
                                    details.delta.dy + offset.dy);
                              });
                            },
                          ),
                        ),
                        // 크기 조정 및 drag 위젯
                        // ResizableBtn(callback, RIGHT),
                      ] +
                      createBtn(),
                );
              }
            }));
  }
}

class ResizableBtn extends StatefulWidget {
  Function callback;
  int direction;

  ResizableBtn(this.callback, this.direction);

  @override
  _ResizableBtnState createState() => _ResizableBtnState(callback, direction);
}

class _ResizableBtnState extends State<ResizableBtn> {
  Function callback;
  int direction;

  _ResizableBtnState(this.callback, this.direction);

  @override
  Widget build(BuildContext context) {
    // 상하
    if (direction == TOP || direction == BOTTOM) {
      return GestureDetector(
        child: Container(
          width: NEMO_SIZE,
          height: NEMO_SIZE,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
            ),
          ),
        ),
        onPanStart: (DragStartDetails details) {
          print("here");
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
          // 방향마다 다 다름 흠..

          // onPanUpdate: (DragUpdateDetails details) {
          // 방향마다 다 다름 흠..
          setState(() {
            callback(details.delta.dx, details.delta.dy, direction);
          });
        },
      );
    }
    // 좌우
    else if (direction == LEFT || direction == RIGHT) {
      return GestureDetector(
        child: Container(
          width: NEMO_SIZE,
          height: NEMO_SIZE,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
            ),
          ),
        ),
        onPanStart: (DragStartDetails details) {
          print("here");
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          // 방향마다 다 다름 흠..

          // onPanUpdate: (DragUpdateDetails details) {
          // 방향마다 다 다름 흠..
          setState(() {
            callback(details.delta.dx, details.delta.dy, direction);
          });
        },
      );
    }
    // 좌상우하
    else if (direction == LEFT + TOP || direction == RIGHT + BOTTOM) {
      return GestureDetector(
        child: Container(
          width: NEMO_SIZE,
          height: NEMO_SIZE,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
            ),
          ),
        ),
        onPanStart: (DragStartDetails details) {
          print("here");
        },
        // onHorizontalDragUpdate: (DragUpdateDetails details) { // 방향마다 다 다름 흠..

        onPanUpdate: (DragUpdateDetails details) {
          // 방향마다 다 다름 흠..
          setState(() {
            double delta;
            if (abs(details.delta.dx) > abs(details.delta.dy)) {
              delta = details.delta.dx;
            } else {
              delta = details.delta.dy;
            }
            callback(delta, delta, direction);
            // callback(details.delta.dx, details.delta.dy, direction);
          });
        },
      );
    } else if (direction == RIGHT + TOP) {
      return GestureDetector(
        child: Container(
          width: NEMO_SIZE,
          height: NEMO_SIZE,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
            ),
          ),
        ),
        onPanStart: (DragStartDetails details) {
          print("here");
        },
        // onHorizontalDragUpdate: (DragUpdateDetails details) { // 방향마다 다 다름 흠..

        onPanUpdate: (DragUpdateDetails details) {
          // 방향마다 다 다름 흠..
          setState(() {
            if (details.delta == Offset(1, -1) ||
                details.delta == Offset(0, -1) ||
                details.delta == Offset(1, 0)) callback(1.0, -1.0, direction);
            else callback(-1.0, 1.0, direction);
          });
        },
      );
    } else {
    // else if (direction == LEFT + BOTTOM) {
      return GestureDetector(
        child: Container(
          width: NEMO_SIZE,
          height: NEMO_SIZE,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
            ),
          ),
        ),
        onPanStart: (DragStartDetails details) {
          print("here");
        },
        // onHorizontalDragUpdate: (DragUpdateDetails details) { // 방향마다 다 다름 흠..

        onPanUpdate: (DragUpdateDetails details) {
          // 방향마다 다 다름 흠..
          setState(() {
            if (details.delta == Offset(1, -1) ||
                details.delta == Offset(0, -1) ||
                details.delta == Offset(1, 0)) callback(1.0, -1.0, direction);
            else callback(-1.0, 1.0, direction);
          });
        },
      );
    }
  }
}

double abs(double num) {
  if (num < 0) return -num;
  return num;
}

double buho(double num) {
  if (num < 0)
    return -1;
  else if (num > 0)
    return 1;
  else
    return 0;
}
