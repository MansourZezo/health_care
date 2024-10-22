import 'package:dio/dio.dart';

class ApiService {
  Dio dio = Dio();
  final String baseUrl = "http://192.168.56.202:3000/api";

  ApiService() {
    dio.options.baseUrl = baseUrl;
    dio.options.headers['Content-Type'] = 'application/json';

    // إضافة validateStatus لقبول الاستجابات الأقل من 500
    dio.options.validateStatus = (status) {
      return status != null && status < 500; // السماح لأي استجابة أقل من 500
    };
  }

  // طلب GET عام
  Future<Response> getRequest(String endpoint) async {
    try {
      Response response = await dio.get(endpoint);
      return response;
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  // طلب POST عام
  Future<Response> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }
}
