import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class FileUploadService {
  final Dio dio;

  FileUploadService(this.dio);

  Future<Response> uploadFile(String filePath, String endpoint,
      {required bool isImage}) async {
    try {
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        isImage ? "profileImage" : "document": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: isImage
              ? MediaType('image', fileName.split('.').last)
              : MediaType('application', 'pdf'), // المستندات كـ PDF
        ),
      });
      Response response = await dio.post(endpoint, data: formData);
      return response;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
}
