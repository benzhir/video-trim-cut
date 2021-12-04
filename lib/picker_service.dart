import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class PickerService {
  final ImagePicker imagePicker;

  PickerService({required this.imagePicker});

  Future<File?> pickVideoFromCamera() async {
    final result = await imagePicker.pickVideo(source: ImageSource.camera);
    if (result != null) return File(result.path);
    return null;
  }

  Future<File?> pickVideoFromGallery() async {
    final result = await imagePicker.pickVideo(source: ImageSource.gallery);
    if (result != null) return File(result.path);
    return null;
  }

  Future<PlatformFile?> pickAudioFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio, /* allowedExtensions: ['mp3'] */
    );
    if (result != null) {
      return result.files.first;
    }
    return null;
  }
  
}
