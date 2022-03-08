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

  ResizableBox(this.offset, this.width, this.height, this.radius, this.color);


  @override
  _ResizableState createState() => _ResizableState(offset, width, height, radius, color);
}

class _ResizableState extends State<ResizableBox> {
  Offset offset;
  double width, height;
  double radius;
  Color color;

  _ResizableState(this.offset, this.width, this.height, this.radius, this.color);

  void callback(double deltaWidth, double deltaHeight) {
    setState(() {
      width = width - deltaWidth;
      height = height - deltaHeight;
      offset = offset + Offset(deltaWidth, deltaHeight);
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
    return Stack(
      children: [
            // 눈에 보여지는 박스가 제일 아래에 오도록
            Positioned(
              top: offset.dy,
              left: offset.dx,
              child: GestureDetector(
                // 여기가 이제 사각형이냐 동그라미냐
                child: Figure(width, height, radius, color),
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
          switch (direction) {
            case LEFT:
              break;
            case TOP:
              break;
            case RIGHT:
              break;
            case BOTTOM:
              break;
            case LEFT + TOP:
              // double newWidth, double newHeight, Offset newOffset
              print("LEFT");
              callback(details.delta.dx, details.delta.dy);
              break;
            case LEFT + BOTTOM:
              break;
            case RIGHT + TOP:
              break;
            case RIGHT + BOTTOM:
              break;
            default:
              break;
          }
        });
      },
    );
  }
}
