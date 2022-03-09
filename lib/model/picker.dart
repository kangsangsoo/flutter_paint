// 경로를 지정하자는게

import 'package:file_picker/file_picker.dart';

Future<String?> fileSaver() async {
  String? fileName = await FilePicker.platform.saveFile();
  return fileName;
}