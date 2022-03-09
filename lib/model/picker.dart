// 경로를 지정하자는게

import 'package:file_picker/file_picker.dart';

Future<String?> fileSaver() async {
  String? fileName = await FilePicker.platform.saveFile();
  return fileName;
}

Future<String?> filePicker() async {
  FileType _pickingType = FileType.image;

  FilePickerResult? fileNames = await FilePicker.platform.pickFiles(
    type: _pickingType,
  );

  return fileNames?.files[0].path;
}