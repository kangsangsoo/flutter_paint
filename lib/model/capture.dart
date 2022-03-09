import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> capture(GlobalKey globalKey, String file) async {
  print("START CAPTURE");
  var renderObject = globalKey.currentContext?.findRenderObject();
  if (renderObject is RenderRepaintBoundary) {
    var boundary = renderObject;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    File imgFile = new File(file);

    imgFile.writeAsBytes(pngBytes!);

  } else {
  }
  print("exit");
  return true;
}