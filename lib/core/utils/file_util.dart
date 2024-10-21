import 'dart:io';
import 'package:flutter/material.dart';

class FileUtil {
  static bool isValidFileFormat(String fileName, List<String> allowedFormats) {
    String extension = fileName.split('.').last.toLowerCase();
    return allowedFormats.contains(extension);
  }

  static bool isFileSizeValid(File file, int maxSizeMB) {
    int fileSizeInBytes = file.lengthSync();
    int maxSizeInBytes = maxSizeMB * 1024 * 1024;
    return fileSizeInBytes <= maxSizeInBytes;
  }

  static void showInvalidFormatMessage(
      BuildContext context, List<String> allowedFormats) {
    String allowedExtensions = allowedFormats.join(', ');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Invalid file format. Only $allowedExtensions are allowed.')),
    );
  }

  static void showFileSizeExceedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File size exceeds the limit of 5MB.')),
    );
  }
}
