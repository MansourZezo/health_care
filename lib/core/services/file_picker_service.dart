import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../utils/file_util.dart';
import 'package:flutter/material.dart';

class FilePickerService {
  final picker = ImagePicker();

  Future<String?> pickImageOrFile(BuildContext context, String fileType,
      {int maxSizeMB = 5}) async {
    if (fileType == 'image') {
      // اختيار صورة من المعرض
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return _validateFile(context, pickedFile.path, maxSizeMB,
            allowedFormats: ['jpg', 'jpeg', 'png']);
      }
    } else {
      // السماح بإرفاق ملفات (مثلاً: pdf، docx، txt)
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf'],  // تأكد من السماح فقط بملفات PDF
        type: FileType.custom,        // تحديد النوع كـ custom لضمان التحكم الكامل في الامتدادات
      );
      if (result != null && result.files.single.path != null) {
        return _validateFile(context, result.files.single.path!, maxSizeMB,
            allowedFormats: ['pdf']); // تحقق من ملفات PDF فقط
      }
    }
    return null;
  }

  String? _validateFile(BuildContext context, String filePath, int maxSizeMB,
      {required List<String> allowedFormats}) {
    File file = File(filePath);
    String fileExtension = filePath.split('.').last.toLowerCase();
    if (!allowedFormats.contains(fileExtension)) {
      FileUtil.showInvalidFormatMessage(context, allowedFormats);
      return null;
    }
    if (!FileUtil.isFileSizeValid(file, maxSizeMB)) {
      FileUtil.showFileSizeExceedMessage(context);
      return null;
    }
    return filePath;
  }
}

