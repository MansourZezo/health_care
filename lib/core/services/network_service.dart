import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '/core/services/api_service.dart';

class NetworkService {
  Dio dio = Dio();

  // دالة للتحقق من الاتصال بالإنترنت
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // دالة للتحقق من الاتصال بالسيرفر
  Future<bool> checkServerConnection() async {
    try {
      final response = await dio.get('${ApiService().baseUrl}/auth/check');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
