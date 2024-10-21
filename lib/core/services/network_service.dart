import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  // دالة للتحقق من الاتصال بالإنترنت
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}
