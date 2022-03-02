import 'package:flutter/material.dart';
import '../model/paint_api.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int mode = -1;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(25),
        child: AppBar(
          flexibleSpace: Container(
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
                                    color: mode == 0
                                        ? Colors.white
                                        : Colors.black),
                              )
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              if (mode == 0)
                                mode = -1;
                              else
                                mode = 0;
                            });
                          },
                        ),
                        InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('block mode')],
                          ),
                          onTap: () {},
                        ),
                        InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('capture mode')],
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
                            children: [Text('pen')],
                          ),
                          onTap: () {},
                        ),
                        InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('eraser')],
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Text(width.toString() + ' ' + height.toString()),
          PaintApi(),
        ],
      ), // 이게 그림판
    );
  }
}
